% realiza a analise dos dados

algos = {'lms', 'nlms', 'selms', 'sdlms', 'sslms', 'rls', 'bndr'};

# prepara para gerar os PNGs
__gnuplot_set__ terminal png small xFFFFFF;

# sinal contaminado
printf ('Sinal Contaminado\n');
cont_fd = fopen ('data/cont.dat', 'rb');
cont = fread (cont_fd, 'double');
__gnuplot_set__ output 'imgs/cont.png';
plot (cont);
title ('Sinal contaminado');
__gnuplot_set__ output 'imgs/cont.png';
replot;

# ruido original
printf ('Ruido Original\n');
ruido_fd = fopen ('data/ruido.dat', 'rb');
ruido = fread (ruido_fd, 'double');
__gnuplot_set__ output 'imgs/ruido.png';
plot (ruido);
title ('Ruido Original');
__gnuplot_set__ output 'imgs/ruido.png';
replot;

# sinal original
printf ('Sinal Original\n');
sinal_fd = fopen ('data/sinal.dat', 'rb');
sinal = fread (sinal_fd, 'double');
__gnuplot_set__ output 'imgs/sinal.png';
plot (sinal);
__gnuplot_set__ output 'imgs/sinal.png';
title ('Sinal original');
replot;

for i=1:length (algos),
	algo = sprintf ('%s', algos{i});
	printf ('Algoritmo: %s\n', algo);
	filename_in   = sprintf ('results/%s.dat', algo);
	filename_out  = sprintf ('imgs/%s.png', algo);
	filename_erro = sprintf ('imgs/%s_erro.png', algo);

	printf ('%s\n', filename_in);
	fd = fopen (filename_in, 'rb');
	y = fread (fd, inf, 'double');
	fclose (fd)


	# Sinal Filtrado
	cmdline = sprintf ("__gnuplot_set__ output '%s'", filename_out);
	eval (cmdline);
	plot (y)
	titulo = sprintf ('Sinal filtrado - %s', algo);
	title (titulo);
	cmdline = sprintf ("__gnuplot_set__ output '%s'", filename_out);
	eval (cmdline);
	replot;

	# Erro
	dif = sinal - y;
	cmdline = sprintf ("__gnuplot_set__ output '%s'", filename_erro);
	eval (cmdline);
	plot (dif);
	titulo = sprintf ('Erro - %s', algo);
	title (titulo);
	cmdline = sprintf ("__gnuplot_set__ output '%s'", filename_erro);
	eval (cmdline);
	replot;
end
