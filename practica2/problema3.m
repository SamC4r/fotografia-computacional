
im=imread('malla.jpg'); 
[N,M,~]=size(im); 

% Calcular imagen auxiliar aux a partir de im 
aux=rgb2gray(im); G=fspecial('gaussian',15,5); aux=imfilter(aux,G); 

% Bucle para marcar los puntos.
figure(1); imshow(im)
lista={'superior izda ','superior drcha','inferior drcha','inferior izda '};
u=zeros(1,4); v=zeros(1,4);  % vectores para guardar coordenadas esquinas   

for k=1:4  
  fprintf('Pincha esquina %s:',lista{k});
  
  [x,y]=ginput(1); 
  [X,Y] = refinar(x,y,aux);

  u(k) = X;
  v(k) = Y;

  fprintf('x=%6.1f,y=%6.1f\t',x,y);
  fprintf('Mejoradas: x=%6.1f,y=%6.1f\n',u(k),v(k));
  
  hold on; 
  plot(x,y,'ro','MarkerFaceCol','r','MarkerSize',3); 
  plot(u(k),v(k),'go','MarkerFaceCol','g','MarkerSize',3); 
  hold off
   
end

%% Continuar aquí el script con el resto de los apartados del script

X = [80, 100, 100, 80];
Y = [ 60,  60, 40, 40 ];

H = get_proy(X,Y,u,v);
vuelca_matriz(H)
fprintf("HAHAHAHAHAHA");
H
%save H2 H (ejecutar bloque anterior con las esquinas del cuadrado pequeno
%de la esquina superior derecha)

load malla_XY.mat
load H1.mat

XY = [X;Y;ones(1,77)]; 
mult =  H*XY;
up = mult(1,:)./mult(3,:);
vp = mult(2,:)./mult(3,:);

u=zeros(1,77); v=zeros(1,77);

 for k=1:77  
  [x2, y2] = refinar(up(1,k),vp(1,k),aux);

  u(k) = x2;
  v(k) = y2;
   
end

du=(u-up); 
dv=(v-vp);
d=sqrt(du.^2+dv.^2);
dm = mean(d);

plot(d);

show_err_malla(du,dv);

H = get_proy(X,Y,u,v);
vuelca_matriz(H);
save H77 H


%%  FUNCIONES AUXILIARES A COMPLETAR   %%

function [x,y]=refinar(x,y,aux)
    R=50; % Definición del tamaño de la zona a explorar
    rr=(-R:R); 
    cx=ones(length(rr),1)*rr; 
    cy=cx';

    xc = round(x);
    yc = round(y);
    
    % Verificar que la ventana esté completamente dentro de la imagen
    [h, w] = size(aux);
    yc = max(R+1, min(yc, h - R));
    xc = max(R+1, min(xc, w - R));
    
    % Extraer subimagen de tamaño (2R+1)x(2R+1)
    s = aux(yc-R:yc+R, xc-R:xc+R);
    s = double(s);
    
    % Calcular pesos: se da más peso a los píxeles más oscuros (cerca del mínimo)
    m = min(s(:));
    d = abs(s - m);
    w = exp(-d);          % peso = e^{-d} )
    w = w / sum(w(:));    % normalizar

    % Desplazamiento ponderado
    dx = sum(sum(w .* cx));
    dy = sum(sum(w .* cy));

    
    % Nueva posición refinada
    x = xc + dx;
    y = yc + dy;
   
end

H
get_data_from_H(H);
function [f,R,X0]=get_data_from_H(H)
    im = imread('malla.jpg'); 
    
    [N,M,~] = size(im); 
    
     
    
    u0 = M/2; 
    
    v0 = N/2; 
    
     
    
    h1 = H(:,1); 
    
    h2 = H(:,2); 
    
     
    
    B = [1 0 -u0; 0 1 -v0; -u0 -v0 u0^2+v0^2]; 
    
    f = sqrt( - (h1' * B * h2) / (H(3,1)*H(3,2)*H(3,3) ) ); 
    
     
    
    K = [f 0 u0; 0 f v0; 0 0 1]; 
    
    Q = K \ H; 
    
     
    
    r1 = Q(:,1); 
    
    r2 = Q(:,2); 
    
     
    
    t = Q(:,3); 
    
     
    
    n1 = norm(r1); 
    
    n2 = norm(r2); 
    
     
    
    lambda = sqrt(n1*n2); 
    
     
    
    r1 = r1 / n1; 
    
    r2 = r2 / n2; 
    
     
    
    t = t / lambda; 
    
     
    
    r3 = cross(r1, r2); 
    
     
    
    R = [r1 r2 r3]; 
    
    X0 = -R' * t; 
 
end

R = convertir_Rw([2, 0.5, 1]);
w = convertir_Rw(R);

function out=convertir_Rw(in)
Ndata=numel(in);
if Ndata==9  % Conversion R --> w
    %MAtriz


  R = in; 
  w=zeros(3,1); % Inicializo vector w 
  % Calcula vector de giro w equivalente a matriz R
  q = [R(3,2) - R(2,3);R(1,3) - R(3,1);R(2,1) - R(1,2)];

  norm_q = norm(q);

  n = q / norm_q;

  r = (R(1,1) + R(2,2)+R(3,3)) - 1;

  rot = atan2(norm_q,r);
    
  w = rot * n;

   
  out=w;  % Asigno w a la salida
elseif Ndata==3  % Conversion w --> R
  w=in;  
  % Calcula matriz de rotacion R equivalente a vector w
    
  norm_w = norm(w);
  n = w / norm_w;
    
  x = n(1); y = n(2); z = n(3);
  M1 = [0 -z y; z 0 -x; -y x 0];
  M2 = n' * n;

  I = eye(3);

  R = cos(norm_w) * I + sin(norm_w) * M1 + (1-cos(norm_w)) * M2;

  out = R;  % Asigno R a la salida 
end    

end

load H77 H;
[f,R,X0] = get_data_from_H(H);
w = convertir_Rw(R);
P0 = [w; X0; f; 0];

f
w
X0

a = error_uv(P0,X,Y,u,v);
norma = norm(a)

du = a(1:77);
dv = a(78:154);

show_err_malla(du,dv);

[N,M,~] = size(im);
den_x = M/23.7;
den_y = N/15.7;


opts=optimset('Algorithm','levenberg-marquardt','Display','off');   
f_min=@(P)error_uv(P,X,Y,u,v)
P=lsqnonlin(f_min,P0,[],[],opts)

nueva_f = P(7)
nueva_w = P(1:3)
nueva_X0= P(4:6)
nueva_k1 = P(8)

an = error_uv(P,X,Y,u,v);
nueva_norma = norm(an)

du = an(1:77);
dv = an(78:154);

show_err_malla(du,dv);

nueva_den = nueva_f/(23.7*15.7)

function err=error_uv(P,X,Y,u,v)

    up = u;
    vp = v;

    w  = P(1:3);
    X0 = P(4:6);
    f  = P(7);
    k1 = P(8);

    R = convertir_Rw(w');
    
    r1 = R(:,1);
    r2 = R(:,2);
    t = -R * X0;


    Q = [r1, r2, t];

    A = [X;Y;ones(1,77)];
    Cam = Q * A;


    
    Zc = Cam(3,:);
    x_norm = Cam(1,:) ./ Zc;
    y_norm = Cam(2,:) ./ Zc;

    r2 = x_norm .^ 2 + y_norm .^ 2;

    x_norm = x_norm.*(1 + k1*r2);
    y_norm = y_norm.*(1 + k1*r2);

    im = imread('malla.jpg');
    [N,M,~] = size(im);
    u0 = M/2;
    v0 = N/2;

    up = u0 + f*x_norm;
    vp = v0 + f*y_norm;

    du = (u - up);
    dv = (v - vp);

    err = [du dv];

end

%% FUNCIONES AUXILIARES PARA USAR (NO MODIFICAR)

% Vuelca valores de una matriz 3x3
function vuelca_matriz(H)
  fprintf('%7.3f %7.3f %8.2f\n',H');
end

% Pintar malla + errores en los nodos como flechas
function show_err_malla(du,dv,S)    
if nargin==2, S=1; end

s=sqrt(du.^2+dv.^2); s=mean(s);

figure;
hold off
for k=1:11, plot([k k],[0.5 7.5],'b'); hold on; end
for k=1:7, plot([0.5 11.5],[k k],'b'); hold on; end

du=flipud(reshape(du/s,11,7)'); 
dv=-flipud(reshape(dv/s,11,7)');
quiver(du,dv,(s/20)*S,'r','LineWidth',2)
hold off
xlim([0 12]); ylim([0 8])

end
