#include <stdio.h>
#include <stdlib.h>

#include "libadapt.h"

unsigned int
read_sample (double *s, FILE *fd)
{
	fread (s, sizeof (*s), 1, fd);

	return (feof (fd));
}

int
main (int argc, char **argv)
{
	FILE *fd_cont, *fd_noise;
	double x, d;
	int	lag = 0, itr = 0;
	
	LMS_CTX   *l;
	
	FILE *fd_lms;
	double e_lms;

	if (argc > 1) lag = atoi (argv [1]);
	printf ("Lag: %d\n", lag);

	fd_cont = fopen ("data/cont.dat", "rb");
	fd_noise = fopen ("data/ruido.dat", "rb");
	
	fd_lms = fopen ("data/lms.dat", "wb");
	l = lms_init (100, 0.05);

	while (!read_sample (&x, fd_noise))
	{
		itr++;
		if (itr > lag)
		{
			if (read_sample (&d, fd_cont))
			{
				printf ("O arquivo contaminado acabou.\n");
				exit (0);
			}
			if ((itr % 3000) == 0) printf ("Iteracao: %d\n", itr);
			e_lms = lms_iter (x, d, l);
			fwrite (&e_lms, sizeof (e_lms), 1, fd_lms);
		} else
		{
			/* Ainda estamos dentro do lag */
			d = 0;
			if ((itr % 3000) == 0) printf ("Iteracao*: %d\n", itr);
		}


	}

	fclose (fd_cont);
	fclose (fd_noise);
	
	fclose (fd_lms);

	lms_free (l);
	return (0);
}
