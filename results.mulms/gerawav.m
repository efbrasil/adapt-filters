clear all;
close all;

mus = {'0.000000', '0.010000', '0.020000', '0.030000', '0.040000', \
       '0.050000', '0.060000', '0.070000', '0.080000', '0.090000', \
       '0.100000', '0.200000', '0.300000', '0.400000', \
       '0.500000', '0.600000', '0.700000', '0.800000', '0.900000'};

length (mus)

for i=1:length (mus),
	dfilename = sprintf ('lms_%s.dat', mus{i});
	wfilename = sprintf ('lms_%s.wav', mus{i});

	fd = fopen (dfilename, 'rb');
	e = fread (fd, inf, 'double');
	fclose (fd);

	e = e / max (e);
	wavwrite (e, 8000, 16, wfilename);
end
