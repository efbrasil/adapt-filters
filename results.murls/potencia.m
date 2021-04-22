clear all;
close all;

% Amostra para convergencia: 4200

% Abre o arquivo original
fd = fopen ('sinal.dat', 'rb');
sinal = fread (fd, inf, 'double');
fclose (fd)

algos = {'0.900000', '0.910000', '0.920000', '0.930000', '0.940000', \
         '0.950000', '0.960000', '0.970000', '0.980000', '0.990000', \
         '0.100000'}

for i=1:length (algos),
	% Gera o título do gráfico, e o nome dos arquivos
	algoname = upper (algos{i});
	fname_filt = sprintf ('rls_%s.dat', algos{i});

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

	% Monta a sequencia de Erro
	erro = filt - sinal;
	erro2 = erro .^ 2;

	% Monta as sequencias de Erro pre-convergia e Erro pos-convergencia
	e_pre = erro (1:4500);
	e_pos = erro (4500:end);
	e_pre2 = e_pre .^ 2;
	e_pos2 = e_pos .^ 2;

	%figure;
	%hold off;

	%subplot (221);
	%escala = linspace (0, length(e_pre)/8000, length (e_pre));
	%plot (escala, e_pre);
	%title ('Erro Pre');

	%subplot (222);
	%escala = linspace (0, length(e_pre2)/8000, length (e_pre2));
	%plot (escala, e_pre2);
	%title ('Erro Pre2');

	%subplot (223);
	%escala = linspace (0, length(e_pos)/8000, length (e_pos));
	%plot (escala, e_pos);
	%title ('Erro Pos');

	%subplot (224);
	%escala = linspace (0, length(e_pos2)/8000, length (e_pos2));
	%plot (escala, e_pos2);
	%title ('Erro Pos2');

	t2 = sprintf ('%s\t%f', algoname, mean (abs (e_pos)));
	%t = sprintf ('Media: %f\nMedia pre = %f\nMedia pos = %f',
	%	mean (abs (erro)),
	%	mean (abs (e_pre)),
	%	mean (abs (e_pos)));
	%disp (algoname)
	disp (t2);





	% Plota o erro
	%figure;
	%hold off
	%escala = linspace (0, length(erro) / 8000, length (erro));
	%plot (escala, erro);
	%grid;
	%legend ('hide');
	%titulo = sprintf ('%s - Erro', algoname);
	%title (titulo);
	%xlabel ('Tempo (s)');
	%ylabel ('Erro');
	%print (fname_img_erro, '-dpng'); 

	%hold off
	%close all
end
