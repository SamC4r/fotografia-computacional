clc; close all;

im1 = imread('willis.jpg');
im2 = imread('ant.jpg');

im1 = im2double(im1);
im2 = im2double(im2);





t = 0.7;
u = (1-t)* x1 + t * x2;
v = (1-t)* y1 + t * y2;

T = delaunay(u,v);
whos T;
NT = 74;

imshow(im2);
hold on
triplot(T,x2,y2);
hold on;
plot(x2,y2, 'r*');

iP1 = cell(1,NT);
iP2 = cell(1,NT);

for k=1:NT
    idx = T(k,:);
    X = x1(idx);
    Y = y1(idx);
    U = u(idx);
    V = v(idx);
    iP1{k} = get_afin(U,V,X,Y);

    X2 = x2(idx);
    Y2 = y2(idx);
    iP2{k} = get_afin(U,V,X2,Y2);
end

show_mat(iP1{3});
show_mat(iP2{3});


function img = warp_img_trozos(im,iP,zona)
    [N,M,~] = size(im);
    img=zeros(N,M,3);
    X = zeros(N,M);
    Y = zeros(N,M);
   
    for k=1:74
        pt = find(zona == k);
        [v,u] = ind2sub(size(zona),pt');
        [x,y] = convertir(u,v,iP{k});
        X(pt) = x;
        Y(pt) = y;
    end
    for c = 1:3
        img(:,:,c) = interp2(im(:,:,c), X, Y, 'bicubic');
    end
end

hold off;
figure;
[N,M,~] = size(im1);
zona1=determina_triang(T,u,v,N,M);
img1 = warp_img_trozos(im1,iP1,zona1);
imshow(img1);

[N2,M2,~] = size(im2);

zona2=determina_triang(T,u,v,N2,M2);
img2 = warp_img_trozos(im2,iP2,zona2);
figure;
imshow(img2);


img_av = (1 - t) * img1 + t*img2;
figure;
imshow(img_av);
function img = warp_img_trozos_optimizada(im, iP, zona)

[N, M, ~] = size(im);

img = zeros(N, M, 3);
X = NaN(N, M);
Y = NaN(N, M);

NT = numel(iP);

for k = 1:NT

    pt = find(zona == k);

    if ~isempty(pt)
        [v, u] = ind2sub(size(zona), pt');
        [x, y] = convertir(u, v, iP{k});

        X(pt) = x;
        Y(pt) = y;
    end

end

for c = 1:3
    img(:, :, c) = interp2(im(:, :, c), X, Y, 'bicubic');
end

end

function img = warp_img_trozos_sin_optimizar(im, iP, zona)

[N, M, ~] = size(im);

img = zeros(N, M, 3);
X = zeros(N, M);
Y = zeros(N, M);

for u = 1:M
    for v = 1:N

        tt = zona(v, u);

        if tt > 0
            [du, dv] = convertir(u, v, iP{tt});
            X(v, u) = du;
            Y(v, u) = dv;
        else
            X(v, u) = NaN;
            Y(v, u) = NaN;
        end

    end
end

for c = 1:3
    img(:, :, c) = interp2(im(:, :, c), X, Y, 'bicubic');
end

end

function P=get_nolineal(x,y,u,v)
    x=x'; y=y'; u=u'; v=v';
    z=0*x; unos=x.^0; % 0's y 1's
    xy = x.*y;
    M = [unos x y xy z z z z; 
         z z z z unos x y xy];

    uv=[u;v]; sol= M\uv;
    P = [sol(1:4)'; sol(5:8)'];
end

PPP = get_nolineal([263,407,680,1], [306,279,800,800],[92,511,498,173], [232,313,766,752]);
show_mat(PPP)

[Du,Dv] = convertir([263,407,680,1],[306,279,800,800],PPP);

dif_u = ([92,511,498,173] -  Du)
dif_v = ([232,313,766,752] - Dv)

iPPP = get_nolineal([92,511,498,173], [232,313,766,752], [263,407,680,1], [306,279,800,800]);
fprintf("iPPP\n");
show_mat(iPPP);

[Dx, Dy] = convertir(Du,Dv,iPPP);

dif_x = ([263,407,680,1] -   Dx)
dif_y = ([306,279,800,800] - Dy)

ima = imread('foto.jpg');
ima=im2double(ima);
morph = warp_img(ima,iPPP);
imshow(morph);

[xx,yy] = convertir(200,100,PPP);
[uu,vv] = convertir(xx,yy,iPPP);

function im2=warp_directo(im,P)
    [N,M,~] = size(im);
    im2 = zeros(N,M,3);
    for y=1:N
        for x=1:M
            [u,v] = convertir(x,y,P);
            u = round(u);
            v = round(v);
            if u >=1 && u <= M && v >= 1 && v <= N
                im2(v,u,:) = im(y,x,:);
            end
        end
    end
end

xd = warp_directo(ima,PPP);
imshow(xd);
