clear all;
close all;

ruido = wavread ('ruido.wav');
cont = wavread ('cont.wav');
sistema = wavread ('sistema.wav');
sinal = wavread ('sinal.wav');

fd = fopen ('ruido.dat', 'wb');
fwrite (fd, ruido, 'double');
fclose (fd);

fd = fopen ('cont.dat', 'wb');
fwrite (fd, cont, 'double');
fclose (fd);

fd = fopen ('sistema.dat', 'wb');
fwrite (fd, sistema, 'double');
fclose (fd);

fd = fopen ('sinal.dat', 'wb');
fwrite (fd, sinal, 'double');
fclose (fd);

