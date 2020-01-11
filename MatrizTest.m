function [res] = MatrizTest(v)
[f c] = size(v);
res = zeros(f,14);
CountO = 0;
CountU = 0;
for i = 1:f
    if v(i, 7) == 0
        if randi(2) == 1
            CountO = CountO + 1;
            res(i, 1) = v(i, 1);
            res(i, 2) = v(i, 2);
            res(i, 3) = v(i, 3);
            res(i, 4) = v(i, 8);
            res(i, 5:1:13) = v(i, 10:1:18);
            res(i, 14) = 0;
        end
        
    else
        prob = randi(4);
        if prob == 1 || prob == 2 || prob == 3
            CountU = CountU + 1;
            res(i, 1) = v(i, 4);
            res(i, 2) = v(i, 5);
            res(i, 3) = v(i, 6);
            res(i, 4) = v(i, 9);
            res(i, 5:1:13) = v(i, 10:1:18);
            res(i, 14) = 1;
        end
        
    end
end
% res(1, 1:1:3) = res(1, 1:1:3)/CountO;
% res(2, 1:1:3) = res(2, 1:1:3)/CountU;
% res(1, 4) = res(1, 4)/CountO;
% res(2, 4) = res(2, 4)/CountU;
% res(1, 5:1:13) = res(1, 5:1:13)/CountO;
% res(2, 5:1:13) = res(2, 5:1:13)/CountU;
end

