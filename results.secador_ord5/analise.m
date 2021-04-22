clear all;
close all;

% Abre o arquivo original
fd = fopen ('sinal.dat', 'rb');
sinal = fread (fd, inf, 'double');
fclose (fd)

algos = {'lms', 'nlms', 'selms', 'sdlms', 'sslms', 'rls', 'bndr'};
%algos = {'lms'};

for i=1:length (algos),
	% Gera o título do gráfico, e o nome dos arquivos
	algoname = upper (algos{i});
	fname_filt = sprintf ('%s.dat', algos{i});
	fname_img_filt = sprintf ('imgs/%s_filt.png', algos{i});
	fname_img_erro = sprintf ('imgs/%s_erro.png', algos{i});
	fname_img_dois = sprintf ('imgs/%s_dois.png', algos{i});

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
	titulo = sprintf ('%s - Sinal Filtrado', algoname);
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
	titulo = sprintf ('%s - Erro', algoname);
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
	titulo = sprintf ('%s - Sinal Original e Erro', algoname);
	title (titulo);
	xlabel ('Tempo (s)');
	print (fname_img_dois, '-dpng'); 

	hold off
	close all
end
