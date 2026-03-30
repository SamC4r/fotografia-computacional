clear; clc; close all

% 3.1)  Lectura y escalado de los datos RAW

raw=imread('raw.pgm');  


im = double(raw) / 4095;

%imshow(im);

% 3.1) Obtencion y procesado imagen BW


R = im(1:2:end,1:2:end); 
G1 = im(1:2:end,2:2:end); 
G2 = im(2:2:end,1:2:end); 
G = (G1 + G2) / 2;
B = im(2:2:end,2:2:end); 

[N,M] = size(im);
a = im(1:6,  M-6:end);
%imshow(a);

r = R(1:3,end-4:end);
g1 = G1(1:3,end-4:end);
g2 = G2(1:3,end-4:end);
b = B(1:3,end-4:end);

max_val = max(im(:));


bw = 0.3 * R + 0.59 * G + 0.11*B;
%histogram(bw(:)); xlim([-0.05 1.05]);




%sat = corregir(bw, 1.02, 0.03) * 100

% 3.2) Demultiplexado, paso a sRGB + gamma


sR = R - 0.14 * G - 0.08 * B;
sG = G - 0.13*R - 0.43 * B;
sB = B + 0.01*R - 0.21 * G;

im = cat(3,sR,sG,sB);
%imshow(im_2);


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

meanR = mean2(sR);
meanG = mean2(sG);
meanB = mean2(sB);
fprintf('Medias: Rojo: %.4f, Verde: %.4f, Azul: %.4f\n', meanR, meanG, meanB);

m = meanG;

c1 = m / meanR;
c2 = m / meanG;
c3 = m / meanB;
fprintf('Factores de corrección: Rojo: %.4f, Verde: %.4f Azul: %.4f \n', c1, c2, c3);

im_wb = im;
im_wb(:,:,1) = im_wb(:,:,1) * c1;
im_wb(:,:,3) = im_wb(:,:,3) * c2;
im_wb = min(max(im_wb, 0), 1);

figure;
imshow(im_wb);
set(gcf, 'Name', 'White Balance');

sat_color = corregir_color(im_wb, 1.03, 0.03) * 100;



% 3.4) Algoritmo alternativo WB

yiq = rgb2ntsc(im);
Y = yiq(:,:,1);
I = yiq(:,:,2);
Q = yiq(:,:,3);

Ymax = max(Y(:));
usar = (Y > 0.66 * Ymax);

rojo = mean(sR(usar));
verde = mean(sG(usar));
azul = mean(sB(usar));
fprintf('máscara (R,G,B): %.4f, %.4f, %.4f\n', rojo, verde, azul);

factorR = verde / rojo;
factorB = verde / azul;
fprintf('Factores de corrección alternativos (Rojo, Azul): %.4f, %.4f\n', factorR, factorB);

im_wb2 = im;
im_wb2(:,:,1) = im_wb2(:,:,1) * factorR;
im_wb2(:,:,3) = im_wb2(:,:,3) * factorB;
im_wb2 = min(max(im_wb2, 0), 1);

%imshow(im_wb2);

im_wb2_1 = im_wb2 .* usar;
%imshow(im_wb2_1);

col = (abs(I) + abs(Q)) ./ Y;
usar_chroma = (col < 0.33);

usar_2 = usar & usar_chroma;

im_wb2_2 = im .* usar_2;

figure;
%imshow(im_wb2_2);
set(gcf, 'Name', 'Píxeles seleccionados (luminancia 66 + croma 33)');

rojo_2 = mean(sR(usar_2));
verde_2 = mean(sG(usar_2));
azul_2 = mean(sB(usar_2));
%fprintf('máscara usar y col (R,G,B): %.4f, %.4f, %.4f\n', rojo_2, verde_2, azul_2);

factorR_2 = verde_2 / rojo_2;
factorB_2 = verde_2 / azul_2;
fprintf('Factores de corrección alternativos 2 (Rojo, Azul): %.4f, %.4f\n', factorR_2, factorB_2);

im_wb2_3 = im;
im_wb2_3(:,:,1) = im_wb2_3(:,:,1) * factorR_2;
im_wb2_3(:,:,3) = im_wb2_3(:,:,3) * factorB_2;
im_wb2_3 = min(max(im_wb2_3, 0), 1);

sat_color_2 = corregir_color(im_wb2_3, 1.02, 0.03) * 100;

% 3.5) Almacenamiento

sat_color_3 = corregir_color_guardar(im_wb2_3, 1.02, 0.03) * 100;

im_90 = imread('foto90.jpg');  
tam_90 = size(im_90);

im_95 = imread('foto95.jpg');  
tam_95 = size(im_95);

im_98 = imread('foto98.jpg');  
tam_98 = size(im_98);

im_sc = imread('foto.tif');  
tam_sc = size(im_sc);

fc_90 = tam_sc/tam_90;
fc_95 = tam_sc/tam_95;
fc_98 = tam_sc/tam_98;

fprintf("factores de compresión 90: %.4f, 95: %.4f, 98: %.4f", fc_90, fc_95, fc_98);


%======================================================%
                    %funciones%
%======================================================%

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

function saturados = corregir_color(im, F, delta)
        for c = 1:3
            m = min(im(:,:,c), [], 'all');
            M = max(im(:,:,c), [], 'all');
            im(:,:,c) = (im(:,:,c) - m) / (M - m);
        end

    im = F * im - delta;
    altoCon = any(im > 1, 3);
    bajoCont = any(im < 0, 3);

    im = min(max(im, 0), 1);

    saturados = (sum(altoCon(:)) + sum(bajoCont(:))) / numel(im(:,:,1));

    figure;
    %histogram(im(:)); xlim([-0.05 1.05]);
    %set(gcf, 'Name', 'Histograma tras WB y corrección');
    imshow(im);
    set(gcf,'Name','Imagen Correccion Brillo-Contraste');
end

function saturados = corregir_color_guardar(im, F, delta)
        for c = 1:3
            m = min(im(:,:,c), [], 'all');
            M = max(im(:,:,c), [], 'all');
            im(:,:,c) = (im(:,:,c) - m) / (M - m);
        end

    im = F * im - delta;
    altoCon = any(im > 1, 3);
    bajoCont = any(im < 0, 3);

    im = min(max(im, 0), 1);

    saturados = (sum(altoCon(:)) + sum(bajoCont(:))) / numel(im(:,:,1));

    figure;
    %histogram(im(:)); xlim([-0.05 1.05]);
    %set(gcf, 'Name', 'Histograma tras WB y corrección');
    imshow(im);
    set(gcf,'Name','Imagen Correccion Brillo-Contraste');

    im = im.*255;

    im = uint8(im);

    imwrite(im,'foto.tif')

    imwrite(im,'foto98.jpg','Quality',98);
    imwrite(im,'foto95.jpg','Quality',95);
    imwrite(im,'foto90.jpg','Quality',90);

end