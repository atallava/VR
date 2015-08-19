% convert neato pose data to apt format
clearAll;
load data/processed_data_160215_sim.mat

%% 
nHold = ceil(0.2*length(trainPoseIds));
holdIds = randsample(trainPoseIds,nHold);
trainIds = setdiff(trainPoseIds,holdIds);

% holdIds = 3;
% trainIds = [1 2 4 5];

% poses
posesHold = poses(:,holdIds);
posesTrain = poses(:,trainIds);
posesTest = poses(:,testIds);

% X data
lzr = robotModel.laser;
bearingIds = 1:360;
bearings = lzr.bearings(bearingIds); % can train using some pixels only

% bearing poses
[XTrain,bearingsTrain,pIdsTrain] = pose2BearingPoses(posesTrain,bearings);
[XHold,bearingsHold,pIdsHold] = pose2BearingPoses(posesHold,deg2rad(0:359));
[XTest,bearingsTest,pIdsTest] = pose2BearingPoses(posesTest,deg2rad(0:359));

% Z data
ZTrain = obsArray(trainIds,bearingIds)'; ZTrain = ZTrain(:);
ZHold = obsArray(holdIds,:)'; ZHold = ZHold(:);
ZTest = obsArray(testIds,:)'; ZTest = ZTest(:);

% Cleanup data
[XTrain,ZTrain,bearingsTrain,pIdsTrain] = cleanupDataForDRegress(XTrain,ZTrain,bearingsTrain,pIdsTrain);
[XHold,ZHold,bearingsHold,pIdsHold] = cleanupDataForDRegress(XHold,ZHold,bearingsHold,pIdsHold);
[XTest,ZTest,bearingsTest,pIdsTest] = cleanupDataForDRegress(XTest,ZTest,bearingsTest,pIdsTest);

%% save data
save('./data/exp11_processed_data_160215.mat','XTrain','pIdsTrain','bearingsTrain','ZTrain','posesTrain',...
    'XHold','pIdsHold','bearingsHold','posesHold','ZHold','XTest','pIdsTest','bearingsTest','ZTest','posesTest');
