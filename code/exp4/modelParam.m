%end to end parametric modeler 

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
trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
%trainPoseIds = [1 3 5];
%trainPoseIds = 1:totalPoses;
testPoseIds = setdiff(1:totalPoses,trainPoseIds);
%testPoseIds = [2 4];
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

%% evaluate how good fit pdfs are
clc;

nllTrain = zeros(length(trainPoseIds),rh.nPixels);
for i = 1:length(trainPoseIds)
    for j = 1:rh.nPixels
        nllTrain(i,j) = fitArray{i,j}.nll;
    end
end

%% fit a regression model to parameters
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
rAlphaTrain = poses2RangeAlpha(roomLineMap,XTrain,rad2deg(rh.bearings));
rAlphaTest = poses2RangeAlpha(roomLineMap,XTest,rad2deg(rh.bearings));

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
        
        % use nll function
        %score = score+nllNormWithDrops(params,data(testPoseIds(i)).z(pixelIds(j),:));
        
        % mse
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
    
    % use function to sample from pdf
    %rangeSim = drawFromNormWithDrops(squeeze(predParamArray(i,:,:)));
    
    xSim = xRob+rangeSim.*cos(rh.bearings+thRob);
    ySim = yRob+rangeSim.*sin(rh.bearings+thRob);
    plot(xSim,ySim,'ro');
    legend('robot','real data','predicted data');
    hold off;
    
    % visualize real and simulated pmfs for a particular pixel index
    hf2 = figure;
    subplot(2,1,1);
    pmfReal = rh.H(poseId,:,pmfPixel);
    pmfReal = pmfReal/sum(pmfReal);
    bar(rh.xCenters,pmfReal);
    title('real pmf');
    subplot(2,1,2);
    params = predParamArray(i,:,pmfPixel);
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

%% visualize training and test poses
clc;
localizer = lineMapLocalizer(lines_p1,lines_p2);

hf = localizer.drawLines();
figure(hf); hold on;
for i = trainPoseIds
    quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'g','LineWidth',2);
end
for i = testPoseIds
    quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'r','LineWidth',2);
end
annotation('textbox',[.6,0.8,.1,.1], ...
    'String', {'green: training poses','red: test poses'});










