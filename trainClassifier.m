function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a table containing the same predictor and response
%       columns as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 16-Dec-2019 15:21:38


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
% Split matrices in the input table into vectors
inputTable.Test_1 = inputTable.Test(:,1);
inputTable.Test_2 = inputTable.Test(:,2);
inputTable.Test_3 = inputTable.Test(:,3);
inputTable.Test_4 = inputTable.Test(:,4);

predictorNames = {'Test_1', 'Test_2', 'Test_3', 'Test_4'};
predictors = inputTable(:, predictorNames);
response = inputTable.Y;
isCategoricalPredictor = [false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationKNN = fitcknn(...
    predictors, ...
    response, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 1, ...
    'DistanceWeight', 'Equal', ...
    'Standardize', true, ...
    'ClassNames', ['B' 'a' 'c' 'k' 'g' 'r' 'o' 'u' 'n' 'd'; 'F' 'o' 'r' 'e' 'g' 'r' 'o' 'u' 'n' 'd']);

% Create the result struct with predict function
splitMatricesInTableFcn = @(t) [t(:,setdiff(t.Properties.VariableNames, {'Test'})), array2table(table2array(t(:,{'Test'})), 'VariableNames', {'Test_1', 'Test_2', 'Test_3', 'Test_4'})];
extractPredictorsFromTableFcn = @(t) t(:, predictorNames);
predictorExtractionFcn = @(x) extractPredictorsFromTableFcn(splitMatricesInTableFcn(x));
knnPredictFcn = @(x) predict(classificationKNN, x);
trainedClassifier.predictFcn = @(x) knnPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'Test'};
trainedClassifier.ClassificationKNN = classificationKNN;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2018b.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
% Split matrices in the input table into vectors
inputTable.Test_1 = inputTable.Test(:,1);
inputTable.Test_2 = inputTable.Test(:,2);
inputTable.Test_3 = inputTable.Test(:,3);
inputTable.Test_4 = inputTable.Test(:,4);

predictorNames = {'Test_1', 'Test_2', 'Test_3', 'Test_4'};
predictors = inputTable(:, predictorNames);
response = inputTable.Y;
isCategoricalPredictor = [false, false, false, false];


% Compute resubstitution predictions
[validationPredictions, validationScores] = predict(trainedClassifier.ClassificationKNN, predictors);

% Compute resubstitution accuracy
validationAccuracy = 1 - resubLoss(trainedClassifier.ClassificationKNN, 'LossFun', 'ClassifError');
