clear all;
close all;

algos = {'lms', 'nlms', 'selms', 'sdlms', 'sslms', 'rls', 'bndr'};

for i=1:length (algos),
	dfilename = sprintf ('%s.dat', algos{i});
	wfilename = sprintf ('%s.wav', algos{i});

	fd = fopen (dfilename, 'rb');
	e = fread (fd, inf, 'double');
	fclose (fd);

	e = e / max (e);
	wavwrite (e, 8000, 16, wfilename);
end
