% convert sensor data to dreg format
% for sensor modeling
in.pre = '../data';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-mapping';
in.date = '150821'; 
in.index = '4';
fname = buildDataFileName(in);
load(fname);

%% convert data

% hand-pick ids
% trainIds = [1 2 3];
% holdIds = [4];

% poses
posesTrain = poses(:,trainIds);
posesHold = poses(:,holdIds);
posesTest = poses(:,testIds);

% X data
% can train on some bearings only
bearingIds = 1:360;
bearings = sensor.bearings(bearingIds); 

% bearing poses
% X is [NB,d]
[XTrain,bearingsTrain,pIdsTrain] = pose2BearingPoses(posesTrain,bearings);
[XHold,bearingsHold,pIdsHold] = pose2BearingPoses(posesHold,deg2rad(0:359));
[XTest,bearingsTest,pIdsTest] = pose2BearingPoses(posesTest,deg2rad(0:359));

% Z data
% Z is [NB,1]. Z{i} is [1,M]
ZTrain = obsArray(trainIds,bearingIds)'; ZTrain = ZTrain(:);
ZHold = obsArray(holdIds,:)'; ZHold = ZHold(:);
ZTest = obsArray(testIds,:)'; ZTest = ZTest(:);

% Cleanup data
[XTrain,ZTrain,bearingsTrain,pIdsTrain] = cleanupDataForDRegress(XTrain,ZTrain,bearingsTrain,pIdsTrain);
[XHold,ZHold,bearingsHold,pIdsHold] = cleanupDataForDRegress(XHold,ZHold,bearingsHold,pIdsHold);
[XTest,ZTest,bearingsTest,pIdsTest] = cleanupDataForDRegress(XTest,ZTest,bearingsTest,pIdsTest);

%% save data
in.tag = 'exp11-mapping-dreg-input';
fname = buildDataFileName(in);
save(fname,'sensor',...
    'XTrain','pIdsTrain','bearingsTrain','ZTrain','posesTrain','trainIds',...
    'XHold','pIdsHold','bearingsHold','ZHold','posesHold','holdIds',...
    'XTest','pIdsTest','bearingsTest','ZTest','posesTest','testIds');
