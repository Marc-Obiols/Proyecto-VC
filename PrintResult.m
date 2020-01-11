function [ResultImage] = PrintResult(Result,I,tam)
% Poner a 1 aquello que es Foreground
[f,c,col] = size(I);

ResultImage = zeros(f,c);
Window = 1;

for i = 1:tam:f
    for j = 1:tam:c

        for k = i:1:i+tam-1
            for z = j:1:j+tam-1
                if Result(Window,1) == 1
                    ResultImage(k,z) = 1;
                end
            end
        end
        Window = Window + 1;
    end
end

end

