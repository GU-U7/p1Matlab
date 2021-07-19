%% Definir variables
X = [];
Y = [];
intervalo = 40;
paso = 1/intervalo;

%% Crear lista de volumenes cada 2 semanas
volumen = [];

%% Definir todos los volumenes desde 01/02/10 hasta 17/01/11 (25 intervalos)
indice_inicio = 1;
indice_fin = indice_inicio+intervalo;
while indice_inicio<size(Y,2)
    suma = Y(indice_inicio);
    for i= indice_inicio+1:2:indice_fin-2
        fprintf("%f, %d, %d\n",suma,i, i+1);
        suma=suma+4*Y(i)+2*Y(i+1);
        disp(suma)
    end
    suma=suma+4*Y(indice_fin-1)+Y(indice_fin);
    simpson13 = suma*paso/3;
    disp(simpson13);
    volumen=[volumen, simpson13];
    indice_inicio = indice_fin;
    indice_fin = indice_inicio+intervalo;
end

