
function qu = quant(v,L)
    distancia = 1 / L; % distancia equidistance de niveles de dcisión
    niveles = (0:L-1) / (L-1);  % niveles de reconstrucción
    valores_recon = 0:distancia:1; % niveles de decision
    qu = -1;
    a = size(valores_recon);

    for i = 1:a(1,2)
        if v <= valores_recon(1,i)
            if i == 1
                qu = 0;
                break
            else 
                qu = niveles(1,i-1);
                break
            end
        end
    end
        
    


