[file,p1] = uigetfile(('*.bmp;*.jpg;*.png;'),"Image to segment");
s1 = strcat(p1,file);
[I, ~] = imread(s1);
    
imshow(I);
rect = getrect;
x1 = rect(1);
x2 = x1 + rect(3);
y1 = rect(2);
y2 = y1 + rect(4);


[f,c,col] = size(I);
BW = zeros(f,c);

x = rect(1) + rect(4);
y = rect(2) + rect(3);

BW(y1:y2, x1:x2) = 1;

Features = features(I, BW, 17);
Test = MatrizTest(Features);


% Prediction
Modelo = trainClassifier(Test);


% Object first image
FeaturesWindow = FeaturesNewImage(I,17);

% Matriz resultado: predicción de cada ventana
[fFtWindow,~] = size(FeaturesWindow);
ResultOG = zeros(fFtWindow,1);

% Calcular predicción por cada ventana
for i = 1:1:fFtWindow
    ResultOG(i,1) = predict(Modelo.ClassificationKNN,FeaturesWindow(i,:));
end

% Pintar resultado
ImResOG = PrintResult(ResultOG,I,17);

% Tratar Imagen Resultado

SE = strel('disk',11);
ImResOG = imclose(ImResOG, SE);
ImRes = imfill(ImResOG,'holes');
ImResOG = imopen(ImResOG, SE);

CC = bwconncomp(ImResOG);
stat = regionprops(CC,'Centroid','Area','PixelIdxList');
[~,index] = max([stat.Area]);
ImResOG(:,:)=0;
ImResOG(stat(index).PixelIdxList)=1;


BlackWhite = edge(ImResOG);
[fN,cN,~] = size(ImResOG);
for i = 1:1:fN
    for j = 1:1:cN
        if BlackWhite(i, j) == 1
            I(i,j,1) = 255;
            I(i,j,2) = 0;
            I(i,j,3) = 0;
        end
    end
end

figure('NumberTitle', 'off', 'Name','Object to segment')
imshow(I);



% Read New Image
[file,p1] = uigetfile(('*.bmp;*.jpg;*.png;'),"Image to predict");
s1 = strcat(p1,file);
[NewImage, map] = imread(s1);

% Extraer features de las ventanas de la nueva imagen
FeaturesWindow = FeaturesNewImage(NewImage,17);

% Prediction
Modelo = trainClassifier(Test);


% Matriz resultado: predicción de cada ventana
[fFtWindow,cFtWindow] = size(FeaturesWindow);
Result = zeros(fFtWindow,1);

% Calcular predicción por cada ventana
for i = 1:1:fFtWindow
    Result(i,1) = predict(Modelo.ClassificationKNN,FeaturesWindow(i,:));
end

% Pintar resultado
ImRes = PrintResult(Result,NewImage,17);

% Tratar Imagen Resultado
SE = strel('disk',11);
ImRes = imclose(ImRes, SE);
ImRes = imfill(ImRes,'holes');
ImRes = imopen(ImRes, SE);

CC = bwconncomp(ImRes);
stat = regionprops(CC,'Centroid','Area','PixelIdxList');
[maxValue,index] = max([stat.Area]);
ImRes(:,:)=0;
ImRes(stat(index).PixelIdxList)=1;


BlackWhite = edge(ImRes);
[fN,cN,colN] = size(NewImage);
for i = 1:1:fN
    for j = 1:1:cN
        if BlackWhite(i, j) == 1
            NewImage(i,j,1) = 255;
            NewImage(i,j,2) = 0;
            NewImage(i,j,3) = 0;
        end
    end
end

figure('NumberTitle', 'off', 'Name','Predicted Object')
imshow(NewImage);
