#include <stdio.h>
#include <stdlib.h>

#include "rls2.h"


#define N_MUS 11

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

	double mu[] = {0.90, 0.91, 0.92, 0.93, 0.94,
		       0.95, 0.96, 0.97, 0.98, 0.99, 1.00};

	int i;
	
	RLS_CTX   *l[N_MUS];
	
	FILE *fd_rls[N_MUS];
	double e_rls[N_MUS];

	fd_cont = fopen ("data/cont.dat", "rb");
	fd_noise = fopen ("data/ruido.dat", "rb");

	for (i = 0; i < N_MUS; i++)
	{
		sprintf (temp_filename, "results/rls_%f.dat", mu[i]);
		fd_rls [i] = fopen (temp_filename, "wb");
		l [i] = rls_init (20, mu [i]);
	}

	while (!read_samples (&d, &x, fd_cont, fd_noise))
	{
		for (i = 0; i < N_MUS; i++)
		{
			e_rls [i] = rls_iter (x, d, l [i]);
			fwrite (&e_rls[i], sizeof (e_rls[i]), 1, fd_rls[i]);
		}
	}

	fclose (fd_cont);
	fclose (fd_noise);
	
	for (i = 0; i < N_MUS; i++)
	{
		fclose (fd_rls [i]);
		rls_free (l [i]);
	}

	return (0);
}
