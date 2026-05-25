clear; clc; close all;

exp_1 = im2double(imread("exp_1.jpg"));
exp_2 = im2double(imread("exp_2.jpg"));
exp_3 = im2double(imread("exp_3.jpg"));


N = 5;

p1 = lap_pir(exp_1,5);
p2 = lap_pir(exp_2,5);
p3 = lap_pir(exp_3,5);

pyr_fusionada = cell(1, 5);

pyr_fusionada{N} = (p1{N} + p2{N} + p3{N}) / 3;


for i = 1:N-1
    [n, M, c] = size(p1{i});
    
    pyr_fusionada{i} = zeros(n, M, c);
    
    for f = 1:n
        for c = 1:M
            rgb1 = squeeze(p1{i}(f, c, :));
            rgb2 = squeeze(p2{i}(f, c, :));
            rgb3 = squeeze(p3{i}(f, c, :));
            
            detalle1 = sum(abs(rgb1));
            detalle2 = sum(abs(rgb2));
            detalle3 = sum(abs(rgb3));
            
            if (detalle1 >= detalle2) && (detalle1 >= detalle3)
                pyr_fusionada{i}(f, c, :) = rgb1;

            elseif (detalle2 >= detalle1) && (detalle2 >= detalle3)
                pyr_fusionada{i}(f, c, :) = rgb2;

            else
                pyr_fusionada{i}(f, c, :) = rgb3;

            end    
        end
    end
end

exp_pyr = inv_lap(pyr_fusionada);

imshow(exp_pyr)

min_exp = min(exp_pyr(:));
max_exp = max(exp_pyr(:));

exp_pyr_rees = (exp_pyr - min_exp) / (max_exp - min_exp);

imshow(exp_pyr_rees)

exp_hsv = rgb2hsv(exp_pyr_rees);

H = exp_hsv(:, :, 1);
S = exp_hsv(:, :, 2);
V = exp_hsv(:, :, 3);

V_exp = adapthisteq(V,"ClipLimit",0.01);

S_exp = S .^0.7;

S_exp(S_exp < 0.0) = 0.0; 
S_exp(S_exp > 1.0) = 1.0;

exp_hsv_final = cat(3, H, S_exp, V_exp);

exp_final = hsv2rgb(exp_hsv_final);

imshow(exp_final)

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

function H=raised_cos(N)
    L=(N - 1) / 2;
    h = zeros(1,N);
    for k=-L:L
        h(k+L+1) = 1 + cos((pi * k) /(L + 1));
    end
    h = h ./ sum(h);
    h;
    H = h' * h;
end

function im=reduce(im)
    H3 = raised_cos(3);
    im=imfilter(im,H3);
    C=im(1:2:end,1:2:end,:);
    im=C;
end


function im2=amplia(im)
    [N,M,~] = size(im);
    Z = zeros(2*N+2,2*M+2,3);
   %Z(1:2:end, 1:2:end,:) = im;
    for i=1:N
        for j=1:M
            Z(2*i,2*j,:)=im(i,j,:);
        end
    end

    Z(end,:,:) = Z(end-1,:,:);
    Z(:,end-1,:) = Z(:,end-1,:);

    H = 1/4 * [1 2 1;
              2 4 2;
              1 2 1];
    
    for c = 1:3
        Z(:,:,c) = imfilter(Z(:,:,c), H);
    end
    
   
    
    Z=Z(2:end-1,2:end-1,:);
    whos Z;
    whos im;
    im2 = Z; 
   
end

function ver_lap(p)

figure('Name','Piramide Laplaciana'); 

L=length(p);  [N,M,Nc]=size(p{1});

res=zeros(N,M,Nc);

dx=0; dy=0;
for k=1:L
  nivel=p{k};
  if k<L, nivel=0.5+2*nivel; end
  nivel([1 2 N-1 N],:,1:2)=0; nivel(:,[1 2 M-1 M],1:2)=0;
  nivel([1 2 N-1 N],:,3)=1; nivel(:,[1 2 M-1 M],3)=1;
  res((1:N)+dy,(1:M)+dx,:)=nivel;
  N=N/2; M=M/2;
end

imshow(res);

end

function im=inv_lap(p)
    N = length(p);
    im = p{N};
    for k=N-1:-1:1
        im = amplia(im);
        %if k == 2
        %    continue
        %end
        im = im + p{k};
    end
end