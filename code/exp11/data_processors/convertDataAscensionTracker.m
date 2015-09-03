% convert sensor data to dreg format
% for sensor modeling
in.pre = '../data';
in.source = 'ascension-tracker';
in.tag = 'exp11-sensor-modeling';
in.date = '150831'; 
in.index = '';
fname = buildDataFileName(in);
load(fname);

%% convert data

% hand-pick ids
% trainIds = [1 2 3];
% holdIds = [4];

% poses
posesTrain = poses(trainIds);
posesHold = poses(holdIds);
posesTest = poses(testIds);

% X data
% can train on some bearings only
bearings = sensor.bearings;

% bearing poses
% X is [NB,d]
XTrain = poses(trainIds);
XHold = poses(holdIds);
XTest = poses(testIds);

% Z data
% Z is [NB,1]. Z{i} is [1,M]
ZTrain = obsArray(trainIds,:)'; ZTrain = ZTrain(:);
ZHold = obsArray(holdIds,:)'; ZHold = ZHold(:);
ZTest = obsArray(testIds,:)'; ZTest = ZTest(:);

% Cleanup data
% [XTrain,ZTrain,bearingsTrain,pIdsTrain] = cleanupDataForDRegress(XTrain,ZTrain,bearingsTrain,pIdsTrain);
% [XHold,ZHold,bearingsHold,pIdsHold] = cleanupDataForDRegress(XHold,ZHold,bearingsHold,pIdsHold);
% [XTest,ZTest,bearingsTest,pIdsTest] = cleanupDataForDRegress(XTest,ZTest,bearingsTest,pIdsTest);

%% save data
in.tag = 'exp11-sensor-modeling-dreg-input';
fname = buildDataFileName(in);
save(fname,'sensor',...
    'XTrain','ZTrain','posesTrain','trainIds',...
    'XHold','ZHold','posesHold','holdIds',...
    'XTest','ZTest','posesTest','testIds');
