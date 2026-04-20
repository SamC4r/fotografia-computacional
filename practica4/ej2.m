clc; close all;

im1 = imread('test1.jpg');
im2 = imread('test2.jpg');

im1=im2double(im1);
im2=im2double(im2);

imshow(im1);
figure;


function H=raised_cos(N)
    L=(N - 1) / 2;
    h = zeros(1,N);
    for k=-L:L
        h(k+L+1) = 1 + cos((pi * k) /(L + 1));
    end
    h = h ./ sum(h);
    h
    H = h' * h;
end



function im=suavizar(im)
    H = raised_cos(5);
    im=imfilter(im,H);
end


d1 = im1 - (suavizar(im1));
d2 = im2 - (suavizar(im2));

R = 15;
T1 = d1(700-R:700+R, 700-R:700+R);
T2 = d2(700-R:700+R, 700-R:700+R);

C=imfilter(T2,T1);

surf(C);

[M,pos]=max(C(:));
[i,j]=ind2sub(size(C),pos);

dX = j - (R + 1)
dY = i - (R + 1)
