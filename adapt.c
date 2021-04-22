#include <stdio.h>
#include <stdlib.h>

#include "libadapt.h"

unsigned int
read_samples (double *d, double *x, FILE *fd_cont, FILE *fd_noise)
{
	fread (d, sizeof (*d), 1, fd_cont);
	fread (x, sizeof (*x), 1, fd_noise);

	return ((feof (fd_cont)) || (feof (fd_noise)));
}

int
main (int argc, char **argv)
{
	FILE *fd_cont, *fd_noise;
	double x, d;
	
	NLMS_CTX  *n;
	LMS_CTX   *l;
	SELMS_CTX *se;
	SDLMS_CTX *sd;
	SSLMS_CTX *ss;
	RLS_CTX *r;
	BNDR_CTX *b;
	
	FILE *fd_nlms, *fd_lms, *fd_selms, *fd_sdlms, *fd_sslms, *fd_rls;
	FILE *fd_bndr;
	double e_nlms, e_lms, e_selms, e_sdlms, e_sslms, e_rls, e_bndr;

	fd_cont = fopen ("data/cont.dat", "rb");
	fd_noise = fopen ("data/ruido.dat", "rb");
	
	fd_lms = fopen ("results/lms.dat", "wb");
	fd_nlms = fopen ("results/nlms.dat", "wb");
	fd_selms = fopen ("results/selms.dat", "wb");
	fd_sdlms = fopen ("results/sdlms.dat", "wb");
	fd_sslms = fopen ("results/sslms.dat", "wb");
	fd_rls = fopen ("results/rls.dat", "wb");
	fd_bndr = fopen ("results/bndr.dat", "wb");

/*
	l = lms_init (10, 0.05);
	n = nlms_init (10, 0.05, 0.5);
	se = selms_init (10, 0.005);
	sd = sdlms_init (10, 0.005);
	ss = sslms_init (10, 0.005);
	r = rls_init (10);
	b = bndr_init (10, 0.02);
*/

/*
	l = lms_init (20, 0.05);
	n = nlms_init (20, 0.05, 0.5);
	se = selms_init (20, 0.005);
	sd = sdlms_init (20, 0.005);
	ss = sslms_init (20, 0.005);
	r = rls_init (20);
	b = bndr_init (20, 0.02);
*/

/*
	l = lms_init (5, 0.05);
	n = nlms_init (5, 0.05, 0.5);
	se = selms_init (5, 0.005);
	sd = sdlms_init (5, 0.005);
	ss = sslms_init (5, 0.005);
	r = rls_init (5);
	b = bndr_init (5, 0.02);
*/

	l = lms_init (100, 0.05);
	n = nlms_init (100, 0.05, 0.5);
	se = selms_init (100, 0.005);
	sd = sdlms_init (100, 0.005);
	ss = sslms_init (100, 0.005);
	r = rls_init (100);
	b = bndr_init (100, 0.02);

	while (!read_samples (&d, &x, fd_cont, fd_noise))
	{
		e_lms = lms_iter (x, d, l);
		fwrite (&e_lms, sizeof (e_lms), 1, fd_lms);

		e_nlms = nlms_iter (x, d, n);
		fwrite (&e_nlms, sizeof (e_nlms), 1, fd_nlms);
		
		e_selms = selms_iter (x, d, se);
		fwrite (&e_selms, sizeof (e_selms), 1, fd_selms);
		
		e_sdlms = sdlms_iter (x, d, sd);
		fwrite (&e_sdlms, sizeof (e_sdlms), 1, fd_sdlms);

		e_sslms = sslms_iter (x, d, ss);
		fwrite (&e_sslms, sizeof (e_sslms), 1, fd_sslms);

		e_rls = rls_iter (x, d, r);
		fwrite (&e_rls, sizeof (e_rls), 1, fd_rls);

		e_bndr = bndr_iter (x, d, b);
		fwrite (&e_bndr, sizeof (e_bndr), 1, fd_bndr);
	}

	fclose (fd_cont);
	fclose (fd_noise);
	
	fclose (fd_lms);
	fclose (fd_nlms);
	fclose (fd_selms);
	fclose (fd_sdlms);
	fclose (fd_sslms);
	fclose (fd_rls);
	fclose (fd_bndr);
	
	lms_free (l);
	nlms_free (n);
	selms_free (se);
	sdlms_free (sd);
	sslms_free (ss);
	rls_free (r);
	bndr_free (b);

	return (0);
}
