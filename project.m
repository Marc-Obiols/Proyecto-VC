[file,p1] = uigetfile(('*.bmp;*.jpg'),"Image to segment");
s1 = strcat(p1,file);
[I, map] = imread(s1);
    
imshow(I);
rect = getrect;
x1 = rect(1);
x2 = x1 + rect(3);
y1 = rect(2);
y2 = y1 + rect(4);
% M = uint8(colfilt(I, [10, 10], 'sliding', @propiedades, rect)); 

[f,c,col] = size(I);
BW = zeros(f,c);
imshow(BW);
figure

x = rect(1) + rect(4);
y = rect(2) + rect(3);

BW(y1:y2, x1:x2) = 1;
imshow(BW);
Features = features(I, BW, 17);

%B = im2col(I,[17 17], 'distinct');

J1 = I(:,:,1);