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

% HOG = extractHOGFeatures(I);

[f,c,col] = size(I);
BW = zeros(f,c);
% imshow(BW);
% figure

x = rect(1) + rect(4);
y = rect(2) + rect(3);

BW(y1:y2, x1:x2) = 1;
% imshow(BW);

Features = features(I, BW, 17);
Test = MatrizTest(Features);



% Extraer features de las ventanas de la nueva imagen
FeaturesWindow = FeaturesNewImage(I,17);

% Prediction
Y = ['Background'; 'Foreground';];
T = table(Test,Y);
Modelo = trainClassifier(T);


% Matriz resultado: predicción de cada ventana
[fFtWindow,cFtWindow] = size(FeaturesWindow);
Result = repmat('',fFtWindow,1);

% Calcular predicción por cada ventana
for i = 1:1:fFtWindow
    Result(i,:) = predict(Modelo.ClassificationKNN,FeaturesWindow(i,:));
end

% Pintar resultado
ImRes = PrintResult(Result,I,17);
figure
imshow(edge(ImRes))




%B = im2col(I,[17 17], 'distinct');
% J1 = I(:,:,1);




