
v = 0:0.01:1;

a = size(v);

for i = 1:a(1,2)
    vq(1,i) = quant(v(1,i), 8);
end

plot(v, vq, 'LineWidth', 1.5);

im = im2double(imread('imagen.png'));
im8 = dither_hilbert_L(im, 8);
imshow(im8);

hist(im8(:), 100);

im = imread('imagen.png');
im_3bits = bitand(im, 224);
imshow(im_3bits);

im_c = imread('color.jpg');
R = im_c(:,:,1);
G = im_c(:,:,2);
B = im_c(:,:,3);
R3 = uint8(floor(double(R) / 32) * 32);
G3 = uint8(floor(double(G) / 32) * 32);
B2 = uint8(floor(double(B) / 64) * 64);
im_332 = cat(3, R3, G3, B2);
imshow([im_332 im_c]);
