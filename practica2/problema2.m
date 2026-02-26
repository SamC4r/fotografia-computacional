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
  
  fprintf('x=%6.1f,y=%6.1f\n',x,y);
  hold on; 
   plot(x,y,'ro','MarkerFaceCol','r','MarkerSize',3); 
  hold off
   
end

%% Continuar aquí el script con el resto de los apartados del script





%%  FUNCIONES AUXILIARES A COMPLETAR   %%

function [x,y]=refinar(x,y,aux)
R=50; % Definición del tamaño de la zona a explorar
rr=(-R:R); cx=ones(length(rr),1)*rr; cy=cx';
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

function [f,R,X0]=get_data_from_H(H)
  % Definir valores de u0, v0

 
end

function out=convertir_Rw(in)
Ndata=numel(in);
if Ndata==9  % Conversion R --> w
  R = in; w=zeros(3,1); % Inicializo vector w 
  % Calcula vector de giro w equivalente a matriz R
   
  out=w;  % Asigno w a la salida
else   % Conversion w --> R
  w=in;  
  % Calcula matriz de rotacion R equivalente a vector w

  out = R;  % Asigno R a la salida 
end    

end

function err=error_uv(P,X,Y,u,v)

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


