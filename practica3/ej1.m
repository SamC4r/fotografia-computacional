clc;

im = imread('black.pgm');
imshow(im);


% Adjuntar el código usado para extraer el resto de los canales.
R  = im(1:2:end,1:2:end);
G1 = im(1:2:end,2:2:end);
G2 = im(2:2:end,1:2:end);
B  = im(2:2:end,2:2:end);



% offset. No. Se observan muchos valores en 0, lo que significa que el
% offset es 0 o muy bajo y por tanto, valores negativos fueron truncados a
% 0.
histogram(double(R(:)),100); 
xlim([-5 25]);


mu = 0;
s = 0.5;
r = mu + s*randn(1000);
fprintf('media=%.2f sigma=%.2f\n',mean2(r),std2(r));



I = round(r);
%I = double(B);
fprintf('mejora -> media=%.2f sigma=%.2f\n',mean2(I),std2(I));
% media=0.00 sigma=0.57

% Probability of value being less than 1.5 for std=1, mean=0
%p1 = normcdf(0.5, mean2(I), std2(I));
%p2 = normcdf(-0.5, mean2(I), std2(I));

%p_0 = p1 - p2

%Estimacion de p_0
p_0 = (numel(I) - nnz(I))/numel(I)
sigma = sqrt(2) / (4*erfinv(p_0))


%volcad el resultado

A = I > 0;
g0 = sum(A(:))
l0 = g0;
ceros = numel(I) - (g0 + l0);
I = I .* (I >= 0);

% primera pregunta
p_0 = (numel(I) - nnz(I))/numel(I)
sigma = sqrt(2) / (4*erfinv(p_0))

% segunda pregunta - Adjuntad el código usado, el valor corregido de p0 y la nueva
% estimación de  (con 2 decimales) usando los valores de la última "imagen" I (una
% vez cuantificados y puestos a 0 los valores negativos

p_0 = ceros/numel(I)
sigma = sqrt(2) / (4*erfinv(p_0))


%%% TABLA %%% 

%       MEJORA       STD2
% R     0.7113       0.46    
% G1    0.6784       0.45
% G2    0.6786       0.45
% B     0.6870       0.45


%%% RUIDO TERMICO


function sigma=estimar(M)
    I = double(M);
    fprintf('std2() -> media=%.2f sigma=%.2f\n',mean2(I),std2(I));
    
     
    A = I > 0;
    g0 = sum(A(:))
    l0 = g0;
    ceros = numel(I) - (g0 + l0);
    p_0 = ceros/numel(I)
    sigma = sqrt(2) / (4*erfinv(p_0))

end

S = zeros(1,numel(T));

for k=1:numel(S)
    S(1,k) = estimar(black(:,:,k));
end

plot(log2(T), S);

% Para log2(T) = -2  => T = 1/4

