clear all;
close all;

% Amostra para convergencia: 4200

% Abre o arquivo original
fd = fopen ('sinal.dat', 'rb');
sinal = fread (fd, inf, 'double');
fclose (fd)

algos = {'lms', 'nlms', 'sdlms', 'selms', 'sslms', 'bndr', 'rls'}

for i=1:length (algos),
	% Gera o título do gráfico, e o nome dos arquivos
	algoname = upper (algos{i});
	fname_filt = sprintf ('%s.dat', algos{i});

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

	t = sprintf ('Media: %f\nMedia pre = %f\nMedia pos = %f',
		mean (abs (erro)),
		mean (abs (e_pre)),
		mean (abs (e_pos)));
	disp (algoname)
	disp (t);
end
