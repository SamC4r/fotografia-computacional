
im = imread('fotografia-computacional/practica1/imagen.png');
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

R3 = M + 0.5 * del;

[h,w] = size(im);


RA = repmat(R3,h/4,w/4);
im2 = (im >= RA);

imshow(im2);
%imshow(im2(110:220,320:440,:));

err = std2(im2-im);

R1 = 0 + (1-0) * rand(128);

B1 = repmat(B,2,2);

imshow([R1 B1]);

G = fspecial('gauss', 7, 1.5);
R1_filt = imfilter(R1, G, 'symm');
B1_filt = imfilter(B1, G, 'symm');

imshow([R1_filt B1_filt]);

B2 = repmat(B,8,8);

im_B = (im >= B2);

imshow(im_B);


im_color = imread('fotografia-computacional/practica1/color.jpg');

R_dith = im_color(:,:,1) >= B2;
G_dith = im_color(:,:,2) >= B2;
B_dith = im_color(:,:,3) >= B2;

im_dith = cat(3, R_dith, G_dith, B_dith);

im_c2 = im2double(im_dith);

imshow(im_c2);


