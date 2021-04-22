#ifndef __RLS2_H__
#define __RLS2_H__

#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>

struct _RLS_CTX
{
	unsigned int size;
	gsl_vector *state;
	gsl_vector *coef;
	gsl_vector *delta;
	gsl_vector *info;
	gsl_vector *ninfo;
	gsl_matrix *icorr;

	gsl_matrix *tmp1, *tmp2;
};

typedef struct _RLS_CTX RLS_CTX;

RLS_CTX *rls_init (unsigned int, double);
void rls_free (RLS_CTX *);
double rls_iter (double, double, RLS_CTX *);

#endif
