clear; clc; close all

% 3.1)  Lectura y escalado de los datos RAW

raw=imread('raw.pgm');  


im = double(raw) / 4095;

imshow(im);

% 3.1) Obtencion y procesado imagen BW


R = im(1:2:end,1:2:end); 
G1 = im(1:2:end,2:2:end); 
G2 = im(2:2:end,1:2:end); 
G = (G1 + G2) / 2;
B = im(2:2:end,2:2:end); 

[N,M] = size(im);
a = im(1:6,  M-6:end);
imshow(a);

r = R(1:3,end-4:end);
g1 = G1(1:3,end-4:end);
g2 = G2(1:3,end-4:end);
b = B(1:3,end-4:end);

max_val = max(im(:));


bw = 0.3 * R + 0.59 * G + 0.11*B;
histogram(bw(:)); xlim([-0.05 1.05]);


function saturados = corregir(im,F,del)
    m = min(im(:));
    M = max(im(:));
    
 

    im = (im - m) / (M - m);
    im = F*im - del;

    %mayores a 1
    g1 = sum(im(:) > 1);

    %menores a 0
    l0 = sum(im(:) < 0);

    im = min(max(0,im),1);
    
    

    saturados = (g1 + l0) / numel(im);


    histogram(im(:)); xlim([-0.05 1.05]);

    set(gcf,'Name','Imagen Correccion Brillo-Contraste');
    %imshow(im);

end

%sat = corregir(bw, 1.02, 0.03) * 100

% 3.2) Demultiplexado, paso a sRGB + gamma


sR = R - 0.14 * G - 0.08 * B;
sG = G - 0.13*R - 0.43 * B;
sB = B + 0.01*R - 0.21 * G;

im = cat(3,sR,sG,sB);
imshow(im);


max_val = max(im(:));

im = max(min(im,1),0);

x0 = 0.00313;
a = 0.055;
g = 2.4;

gamma = @(x) (x < x0) .* (12.92 .* x) + (x >= x0) .* ((1 + a) .* (x .^ (1/g)) - a);

im = gamma(im);
set(gcf,'Name','Imagen sRGB + gamma');

imshow(im);

max(im(:))
% 3.3) Equilibrado de blancos

% 3.4) Algoritmo alternativo WB


% 3.5) Almacenamiento
