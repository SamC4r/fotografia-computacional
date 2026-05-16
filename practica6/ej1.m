clc; close all;

T = 1./[1000 500 250 125 60 30 15 8 4];

[N,M,~] = size(imread("belg_1.jpg"));

P = 9;
hdr_data = zeros(N,M,P);

for k=1:P
    im = imread("belg_"+k+".jpg");
    im = rgb2gray(im);
    hdr_data(:,:,k) = im;
end

muestra_HDR(hdr_data,T);

function Zdata=sample_hdr(hdr_data,n)
   Zdata = hdr_data(1:n:end, 1:n:end,:);
   [N,M,P] = size(Zdata);
   Zdata = reshape(Zdata,N*M,P);
   Zdata = Zdata + 1;
   ptos_iniciales = N*M
   ZZ = [];
   for p=1:N*M
        valid=1;
        for k = 1:P-1
            if Zdata(p,k + 1) < Zdata(p,k)
                valid=0;
                break;
            end
            if k > 1
                if abs(Zdata(p,k) - (Zdata(p,k + 1) + Zdata(p,k - 1))/2) > 25
                    valid=0;
                    break
                end
            end
        end

        if valid == 1
            ZZ(end + 1,:) = Zdata(p,:);
        end
   end
   ptos_finales = length(ZZ)
   Zdata = ZZ;
end

Zdata = sample_hdr(hdr_data, 8);
Zdata = sample_hdr(hdr_data, 16);

figure;
plot(Zdata(10,:));
hold on;
plot(Zdata(140,:));
plot(Zdata(1700,:));
plot(Zdata(1565,:));
