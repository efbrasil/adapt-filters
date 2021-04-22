#include <stdio.h>
#include <stdlib.h>

#include "libadapt.h"


#define N_MUS 20

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
	char temp_filename [128];

	double mu[] = {0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09,
			       0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0};

	int i;
	
	LMS_CTX   *l[N_MUS];
	
	FILE *fd_lms[N_MUS];
	double e_lms[N_MUS];

	fd_cont = fopen ("data/cont.dat", "rb");
	fd_noise = fopen ("data/ruido.dat", "rb");

	for (i = 0; i < N_MUS; i++)
	{
		sprintf (temp_filename, "results/lms_%f.dat", mu[i]);
		fd_lms [i] = fopen (temp_filename, "wb");
		l [i] = lms_init (20, mu [i]);
	}

	while (!read_samples (&d, &x, fd_cont, fd_noise))
	{
		for (i = 0; i < N_MUS; i++)
		{
			e_lms [i] = lms_iter (x, d, l [i]);
			fwrite (&e_lms[i], sizeof (e_lms[i]), 1, fd_lms[i]);
		}
	}

	fclose (fd_cont);
	fclose (fd_noise);
	
	for (i = 0; i < N_MUS; i++)
	{
		fclose (fd_lms [i]);
		lms_free (l [i]);
	}

	return (0);
}
