clc; close all;
im = imread("brick.jpg");

A=imresize(im,0.25);
figure
imshow(A);



H3 = raised_cos(3);
H5 = raised_cos(5);



imx=Red(Red(im));
im=reduce(reduce(im));


figure

subplot(1,3,1);
imshow(A);
title('Original')

subplot(1,3,2)
imshow(imx);
title('reduce')

subplot(1,3,3)
imshow(im);
title('Filtrado coseno')

figure

D=im2double(A);
im2 =amplia(D);
imshow(im2);

im3 = im2double(imread('img.jpg'));

H5 = raised_cos(5);

im3_filt = imfilter(im3, H5);

im3_detalle = im3 - im3_filt;

min_val = min(im3_detalle(:));
max_val = max(im3_detalle(:));

im3_detalle_show = im3_detalle + 0.5;
imshow(im3_detalle_show);

im_rec = im3_filt + 1.8 .* im3_detalle_show;

min_val_2 = min(im_rec(:));
max_val_2 = max(im_rec(:));

im_rec(im_rec < 0) = 0;
im_rec(im_rec > 1) = 1;

im_compara_realce = zeros(768,1024,3);

im_compara_realce(1:1:384,1:1:1024,:) = im3(1:1:384,1:1:1024,:);
im_compara_realce(385:1:768,1:1:1024,:) = im_rec(385:1:768,1:1:1024,:);

imshow(im_compara_realce);


function im=Red(im)
    C=im(1:2:end,1:2:end,:);
    im=C;
end;


function im=reduce(im)
    H3 = raised_cos(3);
    im=imfilter(im,H3);
    C=im(1:2:end,1:2:end,:);
    im=C;
end;


function H=raised_cos(N)
    L=(N - 1) / 2;
    h = zeros(1,N);
    for k=-L:L
        h(k+L+1) = 1 + cos((pi * k) /(L + 1));
    end
    h = h ./ sum(h);
    h
    H = h' * h;
end;


function im2=amplia(im)
    [N,M,~] = size(im);
    Z = zeros(2*N+2,2*M+2,3);
   %Z(1:2:end, 1:2:end,:) = im;
    for i=1:N
        for j=1:M
            Z(2*i,2*j,:)=im(i,j,:);
        end
    end

    Z(end,:,:) = Z(end-1,:,:);
    Z(:,end-1,:) = Z(:,end-1,:);

    H = 1/4 * [1 2 1;
              2 4 2;
              1 2 1];
    
    for c = 1:3
        Z(:,:,c) = imfilter(Z(:,:,c), H);
    end
    
   
    
    Z=Z(2:end-1,2:end-1,:);
    whos Z;
    whos im;
    im2 = Z; 
   
end





