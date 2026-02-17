clear;
clc;

im = imread('fotografia/practica1/imagen.png');
im = im2double(im);

R = rand(size(im));

im2 = (im >= R);
imshow(im2);

err_filt=std2(im-im2);



del = 1;
M = 0;

for a=1:2
    del = del / 4;
    M1 = [(M) (M + 2*del); 
          (M + 3*del) (M + del)];
    M = M1;
end

R3 = M + 0.5 * del

[h,w] = size(im);


RA = repmat(R3,h/4,w/4);
im2 = (im >= RA);

imshow(im2);
%imshow(im2(110:220,320:440,:));

err = std2(im2-im)
