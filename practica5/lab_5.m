clear;

x=[0 600 465];      y=[0 65 680];
u=[275 655 365];    v=[30 285 755];

x_2=[275 655 365 25];   y_2=[30 285 755 340];
u_2=[0 600 465 215];    v_2=[0 65 680 585];

P = get_afin(x,y,u,v);

[u1,v1]=convertir(x,y,P);

ip = get_afin(u,v,x,y);

I = ip * P; % ip es la inversa de p asique para comprobar que realmente es
            % la inversa de p, los multiplicamos entre ellos para hallar
            % la matriz identidad, si el resultado es la matriz identidad 
            % entonces es correcto.


show_mat(ip);


P_proy = get_proy(x_2,y_2,u_2,v_2);
whos P_proy
[u2,v2]=convertir(x_2,y_2,P_proy);
diff_u = u_2 - u2;
diff_v = v_2 - v2;
error_max = max(sqrt(diff_u.^2 + diff_v.^2));


[u_extra,v_extra] = convertir(200,100,P_proy);

ip_proy = get_proy(u_2,v_2,x_2,y_2);
show_mat(ip_proy);
show_mat(P_proy);

I_proy = P_proy * ip_proy;
show_mat(I_proy)

function [u,v] = convertir(x,y,P) % P mayuscula
    mat = [x;y;ones(1, length(x))];
    whos mat;
    mp = P * mat; 
    u = mp(1,:)./ mp(3,:);
    v = mp(2,:)./ mp(3,:);
end

function P=get_proy(x,y,u,v)
    x=x'; y=y'; u=u'; v=v';
    z=0*x; unos=x.^0; % 0's y 1's
    ux = -x.*u; vx = v.*-x;
    uy = u.*-y;  vy = v.*-y;
    M = [x y unos z z z ux uy; 
         z z z x y unos vx vy];
    whos M;
    show_mat(M)
    uv=[u;v]; sol= M\uv;
    whos sol;
    show_mat(sol)
    P = [sol(1:3)'; sol(4:6)'; sol(7) sol(8) 1];
end
