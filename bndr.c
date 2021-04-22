#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>

#include "libadapt.h"

BNDR_CTX *
bndr_init (unsigned int size, double mu)
{
	BNDR_CTX *n;

	n = (BNDR_CTX *) malloc (sizeof (BNDR_CTX));

	n->size = size;
	n->mu = mu;

	n->x1 = gsl_vector_calloc (n->size);
	n->x2 = gsl_vector_calloc (n->size);
	n->delta = gsl_vector_calloc (n->size);
	n->coef = gsl_vector_calloc (n->size);

	return (n);
}

void
bndr_free (BNDR_CTX *n)
{
	gsl_vector_free (n->x1);
	gsl_vector_free (n->x2);
	gsl_vector_free (n->delta);
	gsl_vector_free (n->coef);
	free (n);
	
	return;
}

double
bndr_iter (double x, double d1, BNDR_CTX *n)
{
	double A, B, a, b, c, d, e, den;
	double d2;
	int i;

	/* x2 = x (k - 1) */
	gsl_vector_memcpy (n->x2, n->x1);

	/* update the x1 = x (k) vector */
	for (i = n->size - 2; i>= 0; i--)
	{
		gsl_vector_set (n->x1, i + 1,
						gsl_vector_get (n->x1, i));
	}
	gsl_vector_set (n->x1, 0, x);

	/* 'shift' the d 'vector' */
	d2 = n->d2;
	n->d2 = d1;

	/* evaluate a, b, c, d and e */
	gsl_blas_ddot (n->x1, n->x2, &a);
	gsl_blas_ddot (n->x1, n->x1, &b);
	gsl_blas_ddot (n->x2, n->x2, &c);
	gsl_blas_ddot (n->x1, n->coef, &d);
	gsl_blas_ddot (n->x2, n->coef, &e);

	den = b * c - a * a + 0.0001;
	A = (d1 * c + e * a - d * c - d2 * a) / den;
	B = (d2 * b + d * a - e * b - d1 * a) / den;

	gsl_vector_memcpy (n->delta, n->x1);
	gsl_vector_scale (n->delta, A);
	gsl_vector_scale (n->x2, B);
	gsl_vector_add (n->delta, n->x2);
	gsl_vector_scale (n->delta, n->mu);

	gsl_vector_add (n->coef, n->delta);

	return (d1 - d);
}
