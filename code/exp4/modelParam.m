%% initialize
clear all; clc;
load data_Feb7
load processed_data
rng('shuffle')

totalPoses = size(poses,2);
frac = 0.7;
trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
testPoseIds = setdiff(1:totalPoses,trainPoseIds);
pixelIds = rad2deg(rh.bearings)+1;
Xtrain = poses';
Xtrain = Xtrain(trainPoseIds,:);
Xtest = poses';
Xtest = Xtest(testPoseIds,:);

%% fit distributions to data
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

%% fit a regression model to parameters
clc;

% a regressor object for each pixel
regPixel = regressorClass.empty(rh.nPixels,0);

fnName = 'linearSquared';
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
        params = predictedParamArray(i,:,j); params = squeeze(params);
        
        % use nll method part of class
        tempObj = feval(fitName,params,1);
        score = score+tempObj.negLogLike(realRanges);
        
        % use nll function
        %score = score+nllNormWithDrops(params,data(testPoseIds(i)).z(pixelIds(j),:));
    end
end
score = score/length(pixelIds);


%% visualize samples from prediction
clc;
clear params;

while true
for i = randperm(length(testPoseIds),1)
    % visualize real vs simulated observations for some test pose
    hf1 = figure; axis equal;
    xlabel('x'); ylabel('y');
    hold on;
    randomObs = randi(rh.nObs);
    poseId = testPoseIds(i);
    xRob = poses(1,poseId); yRob = poses(2,poseId); thRob = poses(3,poseId);
    plot(xRob,yRob,'go');
    
    xReal = xRob+data(poseId).z(pixelIds,randomObs)'.*cos(rh.bearings+thRob);
    yReal = yRob+data(poseId).z(pixelIds,randomObs)'.*sin(rh.bearings+thRob);
    plot(xReal,yReal,'b+');
    title(sprintf('pose: (%f,%f,%f)',xRob,yRob,thRob));
   
    % use class method to sample from pdf
    rangeSim = sampleFromParamArray(squeeze(predictedParamArray(i,:,:)),fitName);
    
    % use function to sample from pdf
    %rangeSim = drawFromNormWithDrops(squeeze(predictedParamArray(i,:,:)));
    
    xSim = xRob+rangeSim.*cos(rh.bearings+thRob);
    ySim = yRob+rangeSim.*sin(rh.bearings+thRob);
    plot(xSim,ySim,'ro');
    hold off;
    
    % visualize real and simulated pmfs for a particular pixel index
    pmfPixel = 1;
    hf2 = figure;
    subplot(2,1,1);
    pmfReal = rh.H(poseId,:,pmfPixel);
    pmfReal = pmfReal/sum(pmfReal);
    bar(rh.xCenters,pmfReal);
    title('real pmf');
    subplot(2,1,2);
    params = predictedParamArray(i,:,pmfPixel);
    tempObj = feval(fitName,params,1);
    pmfSim = tempObj.snap2PMF(rh.xCenters);
    bar(rh.xCenters,pmfSim);
    title('simulation pmf');
    suptitle(sprintf('pixel %d',pixelIds(pmfPixel)));
    
    % some fancy positioning for visibility
    figpos1 = get(hf1,'Position'); figpos2 = get(hf2,'Position');
    figwidth = figpos1(3); figshift = floor(figwidth*0.5+10);
    figpos1(1) = figpos1(1)-figshift; figpos2(1) = figpos2(1)+figshift;
    set(hf1,'Position',figpos1); set(hf2,'Position',figpos2);
end
waitforbuttonpress;
close(hf1,hf2);
end









