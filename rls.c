#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>

#include "libadapt.h"

RLS_CTX *
rls_init (unsigned int size)
{
	RLS_CTX *n;
	int i, j;

	n = (RLS_CTX *) malloc (sizeof (RLS_CTX));

	n->size = size;

	n->state = gsl_vector_calloc (n->size);
	n->delta = gsl_vector_calloc (n->size);
	n->coef = gsl_vector_calloc (n->size);

	n->info = gsl_vector_calloc (n->size);
	n->ninfo = gsl_vector_calloc (n->size);

	n->tmp1 = gsl_matrix_calloc (n->size, 1);
	n->tmp2 = gsl_matrix_calloc (n->size, 1);

	n->icorr = gsl_matrix_alloc (n->size, n->size);
	for (i = 0; i < n->size; i++)
		for (j = 0; j < n->size; j++)
			gsl_matrix_set (n->icorr, i, j,	i == j ? 1 : 0);

	return (n);
}

void
rls_free (RLS_CTX *n)
{
	gsl_vector_free (n->state);
	gsl_vector_free (n->delta);
	gsl_vector_free (n->coef);

	gsl_vector_free (n->info);
	gsl_vector_free (n->ninfo);

	gsl_matrix_free (n->icorr);

	gsl_matrix_free (n->tmp1);
	gsl_matrix_free (n->tmp2);
	
	free (n);
	return;
}

double
rls_iter (double x, double d, RLS_CTX *n)
{
	double y, e, q, v;
	int i;

	/* update the state vector */
	for (i = n->size - 2; i>= 0; i--)
	{
		gsl_vector_set (n->state, i + 1,
						gsl_vector_get (n->state, i));
	}
	gsl_vector_set (n->state, 0, x);

	/* evaluate the output */
	gsl_blas_ddot (n->state, n->coef, &y);

	/* evaluate the error */
	e = d - y;

	/* adapt */
	gsl_blas_dgemv (CblasNoTrans, 1, n->icorr, n->state, 0, n->info);
	gsl_blas_ddot (n->state, n->info, &q);
	v = 1 / (1 + q);
	gsl_vector_memcpy (n->ninfo, n->info);
	gsl_vector_scale (n->ninfo, v);

	gsl_vector_memcpy (n->delta, n->ninfo);
	gsl_vector_scale (n->delta, e);
	gsl_vector_add (n->coef, n->delta);

	/* precisamos gerar as matrizes de uma coluna */
	gsl_matrix_set_col (n->tmp1, 0, n->info);
	gsl_matrix_set_col (n->tmp2, 0, n->ninfo);

	gsl_blas_dgemm (CblasNoTrans, CblasTrans, -1.0,
					n->tmp1, n->tmp2, 1.0, n->icorr);
	

	return (e);
}
