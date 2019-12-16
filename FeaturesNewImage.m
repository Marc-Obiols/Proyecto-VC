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
        for k = i:1:i+tam-1
            for z = j:1:j+tam-1
                if (k<f) && (z<c)
                       R = R + uint16(I(k,z,1));
                       G = G + uint16(I(k,z,2));
                       B = B + uint16(I(k,z,3));
                       IL = IL + (uint16(I(k,z,1))+uint16(I(k,z,2))+uint16(I(k,z,3)))/3;           
                else
                   countL = countL + 1; % numero de pixeles fuera de la ventana
                end
            end
        end
        
        FeatureWindow(ContDef,1) =  R/(tam^2-countL-countU);
        FeatureWindow(ContDef,2) =  G/(tam^2-countL-countU);
        FeatureWindow(ContDef,3) =  B/(tam^2-countL-countU);
        FeatureWindow(ContDef,4) =  IL/(tam^2-countL-countU);

        ContDef = ContDef + 1;
    end
end


end

