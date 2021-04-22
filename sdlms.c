#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>

#include "libadapt.h"

SDLMS_CTX *
sdlms_init (unsigned int size, double mu)
{
	SDLMS_CTX *n;

	n = (SDLMS_CTX *) malloc (sizeof (SDLMS_CTX));

	n->size = size;
	n->mu = mu;

	n->state = gsl_matrix_calloc (n->size, 1);
	n->delta = gsl_matrix_calloc (n->size, 1);
	n->coef = gsl_matrix_calloc (n->size, 1);
	n->result = gsl_matrix_calloc (1, 1);

	return (n);
}

void
sdlms_free (SDLMS_CTX *n)
{
	gsl_matrix_free (n->state);
	gsl_matrix_free (n->delta);
	gsl_matrix_free (n->coef);
	gsl_matrix_free (n->result);
	free (n);
	return;
}

double
sdlms_iter (double x, double d, SDLMS_CTX *n)
{
	double y, e, e2, cte;
	int i;

	/* update the state vector */
	for (i = n->size - 2; i>= 0; i--)
	{
		gsl_matrix_set (n->state, i + 1, 0, 
						gsl_matrix_get (n->state, i, 0));
	}
	gsl_matrix_set (n->state, 0, 0, x);

	/* evaluate the output */
	gsl_blas_dgemm (CblasTrans, CblasNoTrans, 1, n->state, n->coef,
					0, n->result);
	y = gsl_matrix_get (n->result, 0, 0);
	
	/* evaluate the error */
	e = d - y;
	
	/* adapt */
	cte = n->mu * e;

	for (i = 0; i < n->size; i++)
	{
		e2 = gsl_matrix_get (n->state, i, 0);
		e2 = e2 >= 0.0 ? 1 : -1;
		gsl_matrix_set (n->delta, i, 0, e2 * cte);
	}
	
	gsl_matrix_add (n->coef, n->delta);

	return (e);
}
