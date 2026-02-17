im = imread('fotografia/practica1/imagen.png');
im = im2double(im);



im2 = im>=0.5;

G=fspecial('gauss',7,1.5); im_filt=imfilter(im2,G,'symm');
err=std2(im-im_filt)

imshow(im2);



function dith = dithering(im)
    [h, w] = size(im);
    e=0;
    for i=1:h
        if mod(i,2) == 1
            for j=1:w
                im(i,j) = im(i,j) + e;
                V = im(i,j);
                im(i,j) = im(i,j) >= 0.5;
                e = (V-im(i,j));
            end
        else
            for j=w:-1:1
                im(i,j) = im(i,j) + e;
                V = im(i,j);
                im(i,j) = im(i,j) >= 0.5;
                e = (V-im(i,j));
            end    
        end
    end
    dith = im;
end

im2 = dithering(im);
%imshow(im2);
%im=im(110:220,320:440,:);
%imshow(im);

G=fspecial('gauss',7,1.5); im_filt=imfilter(im2,G,'symm');
err_dith=std2(im-im_filt)




function hil = hilbert(im,I,J)
    [h, w] = size(im);
    e=0;
    for k=1:h*w
         im(I(k),J(k)) = im(I(k),J(k)) + e;
         V = im(I(k),J(k));
         im(I(k),J(k)) = im(I(k),J(k)) >= 0.5;
         e = (V-im(I(k),J(k)));
    end
    hil = im;
end

hil = hilbert(im,I,J);
%simshow(hil);
%imshow(hil(110:220,320:440,:));

G=fspecial('gauss',7,1.5); im_filt=imfilter(hil,G,'symm');
err_hil = std2(im_filt-im)



function dith = dithering2(im)
    
    
    [h, w] = size(im);
    errors = zeros(h,w);
    for i=1:h
        if mod(i,2) == 1
            for j=1:w
                im(i,j) = im(i,j) + errors(i,j);
                V = im(i,j);
                im(i,j) = im(i,j) >= 0.5;
                e = (V-im(i,j));

                %en derecha
                if j + 1 <= w
                    errors(i,j + 1) = errors(i,j + 1) + e * 4/8;
                elseif j == w && i + 1 <=  h
                    errors(i + 1,j) = errors(i + 1,j) + e;
                end

                %abajo
                if i + 1 <= h
                    errors(i + 1,j) = errors(i + 1,j) + e * 3/8;
                end

                %diag
                if i + 1 <= h && j + 1 <= w
                    errors(i + 1,j + 1) = errors(i + 1,j + 1) + e * 1/8;
                end
            end
        else
            for j=w:-1:1
                im(i,j) = im(i,j) + errors(i,j);
                V = im(i,j);
                im(i,j) = im(i,j) >= 0.5;
                e = (V-im(i,j));
                
                %en izq
                if j  - 1 >= 1
                    errors(i,j - 1) = errors(i,j - 1) + e * 4/8;
                elseif j == 1 && i + 1 <=  h
                    errors(i + 1,j) = errors(i + 1,j) + e;
                end

                %abajo
                if i + 1 <= h
                    errors(i + 1,j) = errors(i + 1,j) + e * 3/8;
                end

                %diag
                if i + 1 <= h && j - 1 >= 1
                    errors(i + 1,j - 1) = errors(i + 1,j - 1) + e * 1/8;
                end
            end    
        end
    end
    dith = im;
end

im2 = dithering2(im);
%imshow(im2);
imshow(im2(110:220,320:440,:));


G=fspecial('gauss',7,1.5); im_filt=imfilter(im2,G,'symm');
err_dith2 = std2(im_filt-im)
%err_dith2 = std2(im2-im)
