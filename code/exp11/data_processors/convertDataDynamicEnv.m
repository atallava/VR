% convert sensor data to dreg format
% for sensor modeling
in.source = 'sim-laser-gencal';
in.tag = 'exp11-dynamic-env';
in.date = '150903'; 
in.index = '';
fname = buildDataFileName(in);
load(fname);

%% convert data
% poses
posesTrain = poses(:,trainIds);
posesHold = poses(:,holdIds);
posesTest = poses(:,testIds);

% X data
% can train on some bearings only
bearingIds = 1:360;
bearings = sensor.bearings(bearingIds); 

% bearing features
% X is [NB,d]
[XTrain,bearingsTrain,pIdsTrain] = pose2BearingFeatures(posesTrain,bearings,map,sensor); 
[XHold,bearingsHold,pIdsHold] = pose2BearingFeatures(posesHold,sensor.bearings,map,sensor);
[XTest,bearingsTest,pIdsTest] = pose2BearingFeatures(posesTest,sensor.bearings,map,sensor);

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
in.pre = '../data/';
in.tag = 'exp11-dynamic-env-dreg-input';
fname = buildDataFileName(in);
save(fname,'sensor',...
    'XTrain','pIdsTrain','bearingsTrain','ZTrain','posesTrain','trainIds',...
    'XHold','pIdsHold','bearingsHold','ZHold','posesHold','holdIds',...
    'XTest','pIdsTest','bearingsTest','ZTest','posesTest','testIds');
