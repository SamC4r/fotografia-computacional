clc; close all;

%im=imread('img.jpg');



%im=im2double(im);
%p=lap_pir(im,5);

%ver_lap(p);


%xd = inv_lap(p);
%imshow(xd);

%if = xd - im;
%mx = max(dif(:))
%mi = min(dif(:))


cara = imread('cara_bonita_2.jpeg');
cara_2 = imread('cara_bonita_1.jpeg');
cara=im2double(cara);
cara_2 = im2double(cara_2);
%imshow(cara);
%imshow(cara_2);
ry=(985:1030); 
rx=(273:648); 
Yorg=900; 
Xorg=461; 
z1=cara(Yorg+ry,Xorg+rx,:);
Xdest=462;
Ydest=900;
z0=cara(Ydest+ry,Xdest+rx,:);

imshow(z0);
%cara(Ydest+ry,Xdest+rx,:)=z1;
%imshow(cara);

%m=crea_mask(size(z0),[90 180]);

%Z = m.*z1 + (1-m).*z0;

%cara(Ydest+ry,Xdest+rx,:)=Z;
%imshow(cara);

%p0=lap_pir(z0,5);
%p1=lap_pir(z1,5);

%mix=cell(1,5);

%for k=1:5
 %   mix{k} = m.*p1{k} + (1-m).*p0{k};
  %  G=fspecial('gauss',7,2.5); 
   % m=imfilter(m,G);
    %m=m(1:2:end,1:2:end);
%end

%xd = inv_lap(mix);
%cara(Ydest+ry,Xdest+rx,:)=xd;
%imshow(cara);
%whos xd;




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

function H=raised_cos(N)
    L=(N - 1) / 2;
    h = zeros(1,N);
    for k=-L:L
        h(k+L+1) = 1 + cos((pi * k) /(L + 1));
    end
    h = h ./ sum(h);
    h
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

function mask=crea_mask(dims,w)

if nargin==1, w=[90 180]; end 

N=dims(1); M=dims(2); 
wy=w(1); wx=w(2);
  
x=(-M/2+1:M/2)/wx; 
y=(-N/2+1:N/2)'/wy; 
r = sqrt(x.^2 + y.^2);

mask = (r<=1); 
mask=double(mask);

end
