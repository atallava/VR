%% fit distributions to data
clear all; clc;
load data_Feb7
load processed_data

totalPoses = size(poses,2);
frac = 0.7;
trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
testPoseIds = setdiff(1:totalPoses,trainPoseIds);

% use the mle class
%{
fitArray = fitNWithDrops.empty;
fitName = 'fitNWithDrops';
fitArray = fitModel(fitArray,fitName,trainIds);
%}

% use the mle function
nMLEParams = fitNormal();
paramArray = zeros(length(trainPoseIds),nMLEParams,rh.nPixels);

pixelIds = rad2deg(rh.bearings)+1;
for i = 1:length(trainPoseIds)
    for j = 1:rh.nPixels
        paramArray(i,:,j) = fitNormal(data(trainPoseIds(i)).z(pixelIds(j),:));
    end
end

%% regress over parameters
clc;

% a regressor object for each pixel
regPixel = regressorClass.empty(rh.nPixels,0);
Xtrain = poses';
Xtrain = Xtrain(trainPoseIds,:);
fnName = 'firstOrderPoly';
nWeights = feval(fnName);
fnArray = repmat({str2func(fnName)},1,nMLEParams);
weights0 = repmat({zeros(1,nWeights)},1,nMLEParams);
for i = 1:rh.nPixels
    regPixel(i) = regressorClass(nMLEParams);
    try
        regPixel(i).regress(fnArray,Xtrain,paramArray(:,:,i),weights0);
    catch
        fprintf('pixelId: %d \n',pixelIds(i));
        warning('REGRESS FAILED');
    end
end

%% predict at test poses
clc;

Xtest = poses';
Xtest = Xtest(testPoseIds,:);
predictedParamArray = zeros(length(testPoseIds),nMLEParams,length(pixelIds));
for i = rh.nPixels
    predictedParamArray(:,:,i) = regPixel(i).predict(Xtest);
end

%% evaluate predictions
clc;

score = 0;
for i = 1%:length(testPoseIds)
    for j = 10%:length(pixelIds)
        score = score+nllNormWithDrops(predictedParamArray(i,:,j),data(testPoseIds(i)).z(pixelIds(j),:));
    end
end
score = score/length(pixelIds);

%% visualize a sample from prediction

hf = figure;














