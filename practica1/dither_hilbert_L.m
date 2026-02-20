function im = dither_hilbert_L(im, L)
    load hilbert I J;  
    e = 0;
    for k = 1:length(I)
        i = I(k); j = J(k);
        v = im(i,j) + e;          % añadir error acumulado
        out = quant(v, L);         % cuantificar a L niveles
        e = v - out;               % nuevo error
        im(i,j) = out;             % guardar resultado
    end
end
