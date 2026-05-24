clc; close all;

exp_1 = im2double(imread("exp_1.jpg"));
exp_2 = im2double(imread("exp_2.jpg"));
exp_3 = im2double(imread("exp_3.jpg"));


function p=lap_pir(im,N)
    p=cell(1,N);
    for k=1:N-1
        im_red=reduce(im);
        im2=amplia(im_red);
        detalle=im - im2;
        p{k} = detalle; 
        im=im_red;
    end
    p{N} = im;
end