%% fit distributions to data
clear all; clc;
load data_Feb7
load processed_data
rng('shuffle')

totalPoses = size(poses,2);
frac = 0.7;
trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
testPoseIds = setdiff(1:totalPoses,trainPoseIds);
pixelIds = rad2deg(rh.bearings)+1;

% use the mle class
fitArray = normWithDrops.empty;
fitName = 'normWithDrops';
fitArray = fitModel(fitArray,fitName,trainPoseIds);
nMLEParams = fitArray(1).nParams;
paramArray = paramObjects2Array(fitArray);
%{
% use the mle function
nMLEParams = fitNormal();
paramArray = zeros(length(trainPoseIds),nMLEParams,rh.nPixels);
for i = 1:length(trainPoseIds)
    for j = 1:rh.nPixels
        paramArray(i,:,j) = fitNormal(data(trainPoseIds(i)).z(pixelIds(j),:));
    end
end
%}

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
for i = 1:rh.nPixels
    predictedParamArray(:,:,i) = regPixel(i).predict(Xtest);
end

%% evaluate predictions
clc;

score = 0;
for i = 1:length(testPoseIds)
    for j = 1:length(pixelIds)
        realRanges = obsArray(testPoseIds(i),pixelIds(j),:);
        realRanges = squeeze(realRanges);
        %fprintf('%d,%d,%f\n',i,j,fitArray(i,j).negLogLike(realRanges));
        % use nll method of class
        %score = score+fitArray(i,j).negLogLike(realRanges);
        
        % use nll function
        score = score+nllNormWithDrops(predictedParamArray(i,:,j),data(testPoseIds(i)).z(pixelIds(j),:));
    end
end
score = score/length(pixelIds);

%% visualize a sample from prediction
clc;
hf = figure;
hold on; axis equal;

for i = randperm(length(testPoseIds),1)
    randomObs = randi(rh.nObs);
    poseId = testPoseIds(i);
    xRob = poses(1,poseId); yRob = poses(2,poseId); thRob = poses(3,poseId);
    plot(xRob,yRob,'go');
    
    xReal = xRob+data(poseId).z(pixelIds,randomObs)'.*cos(rh.bearings+thRob);
    yReal = yRob+data(poseId).z(pixelIds,randomObs)'.*sin(rh.bearings+thRob);
    plot(xReal,yReal,'b+');
   
    % use class method to sample from pdf
    rangeSim = sampleFromParamArray(squeeze(predictedParamArray(i,:,:)),fitName);
    
    % use function to sample from pdf
    %rangeSim = drawFromNormWithDrops(squeeze(predictedParamArray(i,:,:)));
    
    xSim = xRob+rangeSim.*cos(rh.bearings+thRob);
    ySim = yRob+rangeSim.*sin(rh.bearings+thRob);
    plot(xSim,ySim,'ro');
end

hold off;










