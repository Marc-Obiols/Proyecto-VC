function [FeatureWindow] = FeaturesNewImage(I, tam)
% Obtener features de cada ventana -> predict

[f,c,col] = size(I);

sizeF = ceil(f/tam)*ceil(c/tam);
Features = zeros(sizeF,9);
FeatureWindow = zeros(sizeF,4);
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
                       R = R + uint16(I(k,z,1));
                       G = G + uint16(I(k,z,2));
                       B = B + uint16(I(k,z,3));
                       IL = IL + (uint16(I(k,z,1))+uint16(I(k,z,2))+uint16(I(k,z,3)))/3;           
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
        
        FeatureWindow(ContDef,1) =  R/(tam^2-countL-countU);
        FeatureWindow(ContDef,2) =  G/(tam^2-countL-countU);
        FeatureWindow(ContDef,3) =  B/(tam^2-countL-countU);
        FeatureWindow(ContDef,4) =  IL/(tam^2-countL-countU);
        
        xixa = I(i:1:(i+16-countFF), j:1:(j+16-countCF), 1:1:3);
        [hog_2x2, validPoints] = extractHOGFeatures(xixa,'CellSize',[17-countFF 17-countCF], 'BlockSize', [1 1]);
        [pxv pyv] = size(hog_2x2);
        if pyv ~= 0
            FeatureWindow(ContDef,5:1:13) = hog_2x2(1:1:9);
        end
        ContDef = ContDef + 1;
    end
end


end

