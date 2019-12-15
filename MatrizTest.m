function [res] = MatrizTest(v)
[f c] = size(v);
res = zeros(2, c-1);
CountO = 0;
CountU = 0;
for i = 1:f
    if v(i, 7) == 0
        CountO = CountO + 1;
        res(1, 1) = res(1, 1) + v(i, 1);
        res(1, 2) = res(1, 2) + v(i, 2);
        res(1, 3) = res(1, 3) + v(i, 3);
        res(1, 7) = res(1, 7) + v(i, 8);
    else
        CountU = CountU + 1;
        res(2, 4) = res(2, 4) + v(i, 4);
        res(2, 5) = res(2, 5) + v(i, 5);
        res(2, 6) = res(2, 6) + v(i, 6);
        res(2, 8) = res(2, 8) + v(i, 9);
    end
end
res(1, 1:1:3) = res(1, 1:1:3)/CountO;
res(2, 4:1:6) = res(2, 4:1:6)/CountU;
res(1, 7) = res(1, 7)/CountO;
res(2, 8) = res(2, 8)/CountU;
end

