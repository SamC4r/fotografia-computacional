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

Zdata = sample_hdr(hdr_data, 16);
Zdata = sample_hdr(hdr_data, 8);


figure;
plot(Zdata(10,:));
hold on;
plot(Zdata(140,:));
plot(Zdata(1700,:));
plot(Zdata(1565,:));


function g = solve_G(Zdata,T)
    [N,P] = size(Zdata);
    Neq = 254 + N*(P - 1)
    b = zeros(Neq,1);
    
    no_nulos = 2*N*(P - 1) + 3*254
    i = zeros(1,no_nulos);
    j = zeros(1,no_nulos);
    v = zeros(1,no_nulos);

    per = (100 * no_nulos) / (Neq * 256);
    
    eqs = 1;
    bruh = 1;
    for k=1:N
        Z = Zdata(k,:);
        [val,pos] = min(abs(Z - 128));
        Zref = Z(pos);
        Tref = T(pos);

        for t=1:P
            if t ~= pos

                Zk      = Z(t); 
                Tk      = T(t);

                i(bruh) = eqs;
                j(bruh) = Zk; 
                v(bruh) = 1;
                
                bruh = bruh + 1;
    
                i(bruh) = eqs;
                j(bruh) = Zref;
                v(bruh) = -1;

                b(eqs) = log2(Tk/Tref);

                bruh = bruh + 1;
                eqs = eqs + 1;
            end
        end
    end

    for gg=1:254
        i(bruh) = eqs;
        j(bruh) = gg;
        v(bruh) = -1;

        bruh = bruh + 1;

        i(bruh) = eqs;
        j(bruh) = gg + 1; 
        v(bruh) = 2;
       
        bruh = bruh + 1;
        
        i(bruh) = eqs;
        j(bruh) = gg + 2; 
        v(bruh) = -1;

        bruh = bruh + 1;
        eqs = eqs + 1;
        
    end
    
    H = sparse(i,j,v,Neq,256);
    whos H;
    ss = sum(H ~= 0);
    plot(ss)
    g10 = ss(10)
    g20 = ss(20)
end

solve_G(Zdata,T)
