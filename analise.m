% realiza a analise dos dados

cd data;

# prepara para gerar os PNGs
gset terminal png small xFFFFFF;

# sinal contaminado
cont_fd = fopen ('cont.dat', 'rb');
cont = fread (cont_fd, 'double');
gset output 'cont.png';
plot (cont);
title ('Sinal contaminado');
gset output 'cont.png';
replot;

# ruido original
noise_fd = fopen ('noise.dat', 'rb');
noise = fread (noise_fd, 'double');
gset output 'noise.png';
plot (noise);
title ('Ruido Original');
gset output 'noise.png';
replot;

# nlms
nlms_fd = fopen ('nlms.dat', 'rb');
nlms = fread (nlms_fd, 'double');
gset output 'nlms.png';
plot (nlms);
title ('Sinal estimado');
gset output 'nlms.png';
replot;

# sinal original
signal_fd = fopen ('signal.dat', 'rb');
signal = fread (signal_fd, 'double');
gset output 'signal.png';
plot (signal);
gset output 'signal.png';
title ('Sinal original');
replot;

# diferenca entre o sinal original e o estimado
dif = signal - nlms;
gset output 'dif.png';
plot (dif);
title ('Diferenca entre o sinal original e o estimado');
gset output 'dif.png';
replot;

sleep (4);

system ('mv cont.png ~/public_html/');
system ('mv noise.png ~/public_html/');
system ('mv nlms.png ~/public_html/');
system ('mv signal.png ~/public_html/');
system ('mv dif.png ~/public_html/');
