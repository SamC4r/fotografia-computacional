im = imread("black.pgm");


E = zeros(1,12);
S = zeros(1,12);

for k=1:12
    E(k) = mean2(G(:,:,k));
    S(k) =  std2(G(:,:,k));
end

plot(T,E)


c=polyfit(E,S.^2,2)

e = 1:2000;
s = sqrt(c(3) + c(2) * e + c(1)*(e).^2);


plot(E,S,'ro')
hold on
plot(e,s,'b')
