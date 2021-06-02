imagenMatriz = imread("P1/prueba.jpeg");

imagenLC = rgb2ycbcr(imagenMatriz);

dimension = size(imagenLC);

coefCalidad = 1;
qL = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; 14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; 18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; 49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];
qC = [17 18 24 47 99 99 99 99; 18 21 26 66 99 99 99 99; 24 26 56 99 99 99 99 99; 47 66 99 99 99 99 99 99; 99 99 99 99 99 99 99 99; 99 99 99 99 99 99 99 99; 99 99 99 99 99 99 99 99; 99 99 99 99 99 99 99 99];
qImagen  = round([qL, qC, qC]*coefCalidad);

generadaLC = zeros(dimension);

%%%
cuantizada = zeros(dimension);
%%%

for i = 1:dimension(3)
    
    qTemp = qImagen(:, (i-1)*8+1: i*8);
    imagenTemp = imagenLC(:, :, i);
    
    for j = 1:dimension(2)/8
        for k = 1:dimension(1)/8
            subImagen = imagenTemp((j-1)*8+1:j*8, (k-1)*8+1:k*8);
            subImagenDCT = dct2(subImagen);
            
            sDCTQ = round(subImagenDCT./qTemp);
            
            %%%%
            cuantizada((j-1)*8+1:j*8, (k-1)*8+1:k*8, i) = sDCTQ;
            %%%%
            
            sDCTRestaurada = round(qTemp.*sDCTQ);
            
            subImagenRestaurada = idct2(sDCTRestaurada);
            
            generadaLC((j-1)*8+1:j*8, (k-1)*8+1:k*8, i) = subImagenRestaurada;
            
        end
    end
end

generadaLC=uint8(generadaLC);
imagenReducida = ycbcr2rgb(generadaLC);

figure
imshow(imagenReducida)

%%%%%
unica = unique(cuantizada);
cuanLineal = reshape(cuantizada, 1, numel(cuantizada));
prob = zeros(size(unica));

for i=1:dimension(1)*dimension(2)*dimension(3)
    for j=1:size(unica,1)
        if unica(j,1) == cuanLineal(1, i)
            prob(j,1)=prob(j,1)+1;
            break
        end
    end
end

llaves = huffmandict(transpose(unica),transpose(prob/sum(prob)));
clave = huffmanenco(cuanLineal, llaves);
%%%%

%%%%
lCadBinaria = size(clave,2);
bitsTipoDato = 32; %Un entero ocupa 4 bytes en la mayoría de dispositivos
valUnicos = size(unica, 1)*bitsTipoDato ;
repreBinaria = 0;
for i = 1:size(unica, 1)
	repreBinaria = repreBinaria + size(llaves{i},2);
end
memoriaTotal = lCadBinaria + repreBinaria + valUnicos;
%%%%