clear all;
close all;

% Abre o arquivo original
fd = fopen ('sinal.dat', 'rb');
sinal = fread (fd, inf, 'double');
fclose (fd)

mus = {'0.000000', '0.010000', '0.020000', '0.030000', '0.040000', \
       '0.050000', '0.060000', '0.070000', '0.080000', '0.090000', \
       '0.100000', '0.200000', '0.300000', '0.400000', \
       '0.500000', '0.600000', '0.700000', '0.800000', '0.900000'};


for i=1:length (mus),
	% Gera o título do gráfico, e o nome dos arquivos
	algoname = upper (mus{i});
	fname_filt = sprintf ('lms_%s.dat', mus{i});
	fname_img_filt = sprintf ('imgs/lms_%s_filt.png', mus{i});
	fname_img_erro = sprintf ('imgs/lms_%s_erro.png', mus{i});
	fname_img_dois = sprintf ('imgs/lms_%s_dois.png', mus{i});

	% Abre o arquivo com o sinal filtrado
	fd = fopen (fname_filt, 'rb');
	filt = fread (fd, inf, 'double');
	fclose (fd);

	% Retira o offset DC
	sinal = sinal - mean (sinal);
	filt  = filt  - mean (filt);

	% Iguala a energia do sinal original e do sinal filtrado
	msinal = mean (sinal .^ 2);
	mfilt  = mean (filt  .^ 2);

	filt = filt * sqrt (msinal / mfilt);

	% Plota o sinal filtrado
	figure;
	hold off
	escala = linspace (0, length(filt) / 8000, length (filt));
	plot (escala, filt);
	grid;
	legend ('hide');
	titulo = sprintf ('LMS (mu = %s) - Sinal Filtrado', algoname);
	title (titulo);
	xlabel ('Tempo (s)');
	ylabel ('Sinal Filtrado');
	print (fname_img_filt, '-dpng'); 

	% Plota o erro
	figure;
	hold off
	escala = linspace (0, length(filt) / 8000, length (filt));
	plot (escala, filt - sinal);
	grid;
	legend ('hide');
	titulo = sprintf ('LMS (mu = %s) - Erro', algoname);
	title (titulo);
	xlabel ('Tempo (s)');
	ylabel ('Erro');
	print (fname_img_erro, '-dpng'); 

	% Plota os dois juntos
	figure;
	escala = linspace (0, length(sinal) / 8000, length (sinal));
	plot (escala, sinal);
	hold on
	plot (escala, filt - sinal, "b");
	legend ('Sinal Original', 'Erro');
	grid;
	titulo = sprintf ('LMS (mu = %s) - Sinal Original e Erro', algoname);
	title (titulo);
	xlabel ('Tempo (s)');
	print (fname_img_dois, '-dpng'); 

	hold off
	close all
end
