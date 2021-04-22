clear all;
close all;

algos = {'lms', 'nlms', 'selms', 'sdlms', 'sslms', 'rls', 'bndr'};

for i=1:length (algos),
	titulo = sprintf ('%s', algos{i});
	filename = sprintf ('%s.dat', algos{i});

	fd = fopen (filename, 'rb');
	e = fread (fd, inf, 'double');
	fclose (fd);

	figure;
	escala = linspace (0, length(e) / 8000, length (e));;
	plot (escala, e);
	grid;
	title (titulo);
end
