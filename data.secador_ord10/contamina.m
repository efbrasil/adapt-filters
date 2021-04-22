clear all;
close all;

ruido = wavread ('ruido.wav');
sinal = wavread ('sinal.wav');

ruido = ruido / max (ruido);
sinal = sinal / max (sinal);

h = [7 -9 3 -1 5 -2 8 3 1 -6]';
h = h / sum (h .^ 2);

cont = filter (h, 1, ruido);
cont = cont / max (cont);

ruido = ruido (1:length (sinal));
cont = cont (1:length (sinal));
sistema = cont;
cont = cont + sinal;
cont = cont / max (cont);

wavwrite (ruido, 8000, 16, 'ruido.wav');
wavwrite (cont, 8000, 16, 'cont.wav');
wavwrite (sistema, 8000, 16, 'sistema.wav');
