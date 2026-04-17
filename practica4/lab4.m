clc; close all;
im = imread("brick.jpg");

A=imresize(im,0.25)
figure
imshow(A);

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

H3 = raised_cos(3)
H5 = raised_cos(5)

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

D=im2double(A);
im2 =amplia(D);
imshow(im2);



