clear all;
close all;

ruido = wavread ('ruido.wav');
cont = wavread ('cont.wav');

fd = fopen ('ruido.dat', 'wb');
fwrite (fd, ruido, 'double');
fclose (fd);

fd = fopen ('cont.dat', 'wb');
fwrite (fd, cont, 'double');
fclose (fd);
