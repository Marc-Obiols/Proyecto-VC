function [Features] = features(I,BW, tam)
[f,c,col] = size(I);

sizeF = ceil(f/tam)*ceil(c/tam);
Features = zeros(sizeF,18);
ContDef = 1;

for i = 1:tam:f
    for j = 1:tam:c
        R = 0;
        G = 0;
        B = 0;
        RC = 0;
        GC = 0;
        BC = 0;
        IL = 0;
        ILC = 0;
        countU = 0;
        countL = 0;
        countFF = 0;
        countCF = 0;
        for k = i:1:i+tam-1
            for z = j:1:j+tam-1
                if (k<f) && (z<c)
                   if BW(k,z) == 0
                       R = R + uint16(I(k,z,1));
                       G = G + uint16(I(k,z,2));
                       B = B + uint16(I(k,z,3));
                       IL = IL + (uint16(I(k,z,1))+uint16(I(k,z,2))+uint16(I(k,z,3)))/3;
                   else
                       RC = RC + uint16(I(k,z,1));
                       GC = GC + uint16(I(k,z,2));
                       BC = BC + uint16(I(k,z,3));
                       ILC = ILC + (uint16(I(k,z,1))+uint16(I(k,z,2))+uint16(I(k,z,3)))/3;
                       countU = countU + 1; % numero de 1
                   end
                else
                   countL = countL + 1; % numero de pixeles fuera de la ventana
                   if (z > c)
                       countCF = countCF + 1;
                   end
                end
            end
            if (k > f)
                countFF = countFF + 1;
            end
        end
        
        countCF = countCF / 17;
        % media de color FONDO por ventana
        Features(ContDef,1) = R/(tam^2-countL-countU);
        Features(ContDef,2) = G/(tam^2-countL-countU);
        Features(ContDef,3) = B/(tam^2-countL-countU);
        Features(ContDef,8) = IL/(tam^2-countL-countU);
        
        % media de color OBJETO por ventana
        Features(ContDef,4) = RC/(countU);
        Features(ContDef,5) = GC/(countU);
        Features(ContDef,6) = BC/(countU);
        Features(ContDef,9) = ILC/(countU);
        
        xixa = I(i:1:(i+16-countFF), j:1:(j+16-countCF), 1:1:3);
        [hog_2x2, validPoints] = extractHOGFeatures(xixa,'CellSize',[17-countFF 17-countCF], 'BlockSize', [1 1]);
        [pxv pyv] = size(hog_2x2);
        if pyv ~= 0
            Features(ContDef,10:1:18) = hog_2x2(1:1:9);
        end
        if countU > 130 && countU < 160
            meanR = (R + RC)/(tam^2-countL);
            meanG = (G + GC)/(tam^2-countL);
            meanB = (B + BC)/(tam^2-countL);
            suma = zeros(3,1);
            for k = i:1:i+tam-1
                for z = j:1:j+tam-1
                   if (k<f) && (z<c)
                       suma(1) = suma(1) + (uint16(I(k,z,1)) - meanR)^2;
                       suma(2) = suma(2) + (uint16(I(k,z,2)) - meanG)^2;
                       suma(3) = suma(3) + (uint16(I(k,z,3)) - meanB)^2;
                   end
                end
            end
            suma = suma./(tam^2-countL);
%             disp(suma);
            Features(ContDef,7) = 0;
            
        elseif countU < 131
            Features(ContDef,7) = 0; %FONDO
        elseif countU > 159
            Features(ContDef,7) = 1; %OBJETO
        end
        ContDef = ContDef + 1;
    end
end
end
