% convert neato pose data to apt format
clearAll;
load ../exp4/mats/processed_data_sep6.mat
% load mats/processed_data_sep6_2.mat
load ../exp4/mats/roomLineMap.mat

%% 
nHold = ceil(0.2*length(trainPoseIds));
holdIds = randsample(trainPoseIds,nHold);
trainIds = setdiff(trainPoseIds,holdIds);
trainIds = trainPoseIds;
testIds = testPoseIds;

holdIds = [3 6 15 17];
trainIds = setdiff(1:21,holdIds);

% poses
posesHold = poses(:,holdIds);
posesTrain = poses(:,trainIds);
posesTest = poses(:,testIds);

% X data
lzr = laserClass(struct());
bearingIds = 1:360;
bearings = lzr.bearings(bearingIds); % can train using some pixels only

% bearing poses
% [XTrain,bearingsTrain,pIdsTrain] = pose2BearingPoses(posesTrain,bearings);
% [XHold,bearingsHold,pIdsHold] = pose2BearingPoses(posesHold,deg2rad(0:359));
% [XTest,bearingsTest,pIdsTest] = pose2BearingPoses(posesTest,deg2rad(0:359));

% bearing features
[XTrain,bearingsTrain,pIdsTrain] = pose2BearingFeatures(posesTrain,bearings,map);
[XHold,bearingsHold,pIdsHold] = pose2BearingFeatures(posesHold,deg2rad(0:359),map);
[XTest,bearingsTest,pIdsTest] = pose2BearingFeatures(posesTest,deg2rad(0:359),map);

% Z data
ZTrain = obsArray(trainIds,bearingIds)'; ZTrain = ZTrain(:);
ZHold = obsArray(holdIds,:)'; ZHold = ZHold(:);
ZTest = obsArray(testIds,:)'; ZTest = ZTest(:);

% Cleanup data
[XTrain,ZTrain,bearingsTrain,pIdsTrain] = cleanupDataForDRegress(XTrain,ZTrain,bearingsTrain,pIdsTrain);
[XHold,ZHold,bearingsHold,pIdsHold] = cleanupDataForDRegress(XHold,ZHold,bearingsHold,pIdsHold);
[XTest,ZTest,bearingsTest,pIdsTest] = cleanupDataForDRegress(XTest,ZTest,bearingsTest,pIdsTest);

%% save data
save('./mats/exp11_processed_data_sep6.mat','XTrain','pIdsTrain','bearingsTrain','ZTrain','posesTrain','trainIds',...
    'XHold','pIdsHold','bearingsHold','posesHold','holdIds','ZHold','XTest','pIdsTest','bearingsTest','ZTest','posesTest','testIds');
