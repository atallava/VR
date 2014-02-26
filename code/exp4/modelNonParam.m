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
   
    rangeSim = sampleFromHistArray(squeeze(predHistArray(i,:,:)),rh.xCenters);
    
    xSim = xRob+rangeSim.*cos(rh.bearings+thRob);
    ySim = yRob+rangeSim.*sin(rh.bearings+thRob);
    plot(xSim,ySim,'ro');
end

hold off;
