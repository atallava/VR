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
XTrain = poses';
XTrain = XTrain(trainPoseIds,:);
XTest = poses';
XTest = XTest(testPoseIds,:);

%% predict histograms at test poses
clc;
trainHistArray = rh.H(trainPoseIds,:,:);
testHistArray = rh.H(testPoseIds,:,:);
predHistArray = zeros(size(testHistArray)); 

for i = 1:length(pixelIds)
    predHistArray(:,:,i) = npRegressor(XTrain,trainHistArray(:,:,i),XTest,'kernelBox');
end

%% test predictions
% score for how similar two histograms are

avgScore = 0;
for i = 1:length(testPoseIds)
    for j = 1:rh.nPixels
        avgScore = avgScore+histSimilarity(predHistArray(i,:,j),testHistArray(i,:,j));
    end
end
avgScore = avgScore/(length(testPoseIds)*rh.nPixels);

%% visualize sample from predictions
clc;

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
   
    rangeSim = sampleFromHistArray(squeeze(predHistArray(i,:,:)),rh.xCenters);
    if any(isnan(rangeSim))
        error('UNABLE TO PREDICT HISTOGRAM AT POSE');
    end
        
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
    pmfSim = predHistArray(i,:,pmfPixel);
    pmfSim = pmfSim/sum(pmfSim);
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













