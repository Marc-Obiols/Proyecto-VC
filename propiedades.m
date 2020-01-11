function [y] = propiedades(x)
    [f, c] = size(x);
    disp(f);
    disp(c);
    y(1,1:1:c) = x(ceil(f/2),:);
end

