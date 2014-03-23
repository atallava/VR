%end to end parametric modeler
%WARNING: most of this is outdated and will not work

%% initialize
clear all; clear classes; clc;
load data_Feb7
load processed_data
load poses_from_range_matching
load map
rng('shuffle')

poses = posesFromRangeMatching;
totalPoses = 20; %only first 20 poses have legible range readings
frac = 0.7;
%trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
trainPoseIds = 1:2:20;
testPoseIds = setdiff(1:totalPoses,trainPoseIds);
pixelIds = rad2deg(rh.bearings)+1;
XTrain = poses';
XTrain = XTrain(trainPoseIds,:);
XTest = poses';
XTest = XTest(testPoseIds,:);

%% fit distributions to data
clc;

% use the mle class
fitName = 'normWithDrops';
fitArray = fitModel(fitName,obsArray,rh,trainPoseIds);
nMLEParams = fitArray{1}.nParams;
trainParamArray = paramObjects2Array(fitArray);

%% evaluate how good fit pdfs are
clc;

nllTrain = zeros(length(trainPoseIds),rh.nPixels);
for i = 1:length(trainPoseIds)
    for j = 1:rh.nPixels
        nllTrain(i,j) = fitArray{i,j}.nll;
    end
end

%% visualize outliers
clear params;
pdfOutliers = outlierDiagnostic(nllTrain,{trainPoseIds, 1:rh.nPixels});
for i = 1:length(pdfOutliers)
    poseId = pdfOutliers(i,1);
    pmfPixel = pdfOutliers(i,2);
    params = trainParamArray(find(trainPoseIds == poseId),:,pmfPixel);
    hf = vizPMFs(rh,poseId,pmfPixel,params,fitName);
    fprintf('nll(%d,%d): %f\n',poseId,pmfPixel,nllTrain(find(trainPoseIds == poseId),pmfPixel));
    waitforbuttonpress;
    close(hf);
end

%% fit a regression model to parameters
% also example of using object arrays
clc;

% a regressor object for each pixel
regPixel = regressorClass.empty(rh.nPixels,0);

fnArray = {@firstOrderPoly,@linearSquared, @linearSquaredSquashed};
weights0 = {zeros(1,4), zeros(1,4), zeros(1,4)};
for i = 1:rh.nPixels
    regPixel(i) = regressorClass(nMLEParams);
    try
        regPixel(i).regress(fnArray,XTrain,trainParamArray(:,:,i),weights0);
    catch
        fprintf('pixelId: %d \n',pixelIds(i));
        error('REGRESS FAILED');
    end
end

%% alternate: fit a locally weighted regression model to parameters

%% evaluate how good fit model is
clc;

% MSE for each pixel for each parameter
mseTrain = zeros(nMLEParams,rh.nPixels);
for j = 1:rh.nPixels
    mseTrain(:,j) = regPixel(j).getMSE();
end

%% predict at test poses
clc;

predParamArray = zeros(length(testPoseIds),nMLEParams,length(pixelIds));
for i = 1:rh.nPixels
    predParamArray(:,:,i) = regPixel(i).predict(XTest);
end

%% alternate: predict parameters via NN-regression
clc;

predParamArray = zeros(length(testPoseIds),nMLEParams,rh.nPixels);

for i = 1:rh.nPixels
    predParamArray(:,:,i) = npRegressor(XTrain,trainParamArray(:,:,i),XTest,'kernelInvPoseDist');
end

%% alternate: predict parameters via NN-regression over (range, incidence_angle)
clc;

predParamArray = zeros(length(testPoseIds),nMLEParams,rh.nPixels);
rAlphaTrain = poses2RAlpha(roomLineMap,XTrain,rh.bearings);
rAlphaTest = poses2RAlpha(roomLineMap,XTest,rh.bearings);

for i = 1:rh.nPixels
    [predParamArray(:,:,i),flu] = npRegressor(rAlphaTrain(:,:,i),trainParamArray(:,:,i),rAlphaTest(:,:,i),'kernelRAlpha');
end

%% evaluate predictions 
clc;

nllTest = zeros(length(testPoseIds),length(pixelIds));
seTest = zeros(size(predParamArray));
for i = 1:length(testPoseIds)
    for j = 1:length(pixelIds)
        realRanges = obsArray(testPoseIds(i),:,pixelIds(j));
        realRanges = squeeze(realRanges);
        params = predParamArray(i,:,j); params = squeeze(params);
        
        % use nll method part of class
        tempObj = feval(fitName,params,1);
        nllTest(i,j) = tempObj.negLogLike(realRanges);
        
        % squared error
        tempObj = feval(fitName,realRanges,0);
        seTest(i,:,j) = (params-tempObj.getParams())'.^2;
    end
end
avgNllTest = sum(nllTest(:))/(length(testPoseIds)*length(pixelIds));

%% visualize samples from prediction
clc;
clear params;

pmfPixel = randperm(rh.nPixels,1);
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
    title(sprintf('pose %d: (%f,%f,%f)',poseId,xRob,yRob,thRob));
   
    % use class method to sample from pdf
    rangeSim = sampleFromParamArray(squeeze(predParamArray(i,:,:)),fitName);
        
    xSim = xRob+rangeSim.*cos(rh.bearings+thRob);
    ySim = yRob+rangeSim.*sin(rh.bearings+thRob);
    plot(xSim,ySim,'ro');
    legend('robot','real data','predicted data');
    hold off;
    
    % visualize real and simulated pmfs for a particular pixel index
    params = predParamArray(i,:,pmfPixel);
    hf2 = vizPMFs(rh,poseId,pmfPixel,params,fitName);
      
    % some fancy positioning for visibility
    figpos1 = get(hf1,'Position'); figpos2 = get(hf2,'Position');
    figwidth = figpos1(3); figshift = floor(figwidth*0.5+10);
    figpos1(1) = figpos1(1)-figshift; figpos2(1) = figpos2(1)+figshift;
    set(hf1,'Position',figpos1); set(hf2,'Position',figpos2);
end
waitforbuttonpress;
close(hf1,hf2);
end

%% visualize training and test poses
clc;
localizer = lineMapLocalizer(lines_p1,lines_p2);
hf = vizPoses(localizer,poses,trainPoseIds,testPoseIds);










