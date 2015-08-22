% convert sensor data to dreg format
% for sensor modeling
in.pre = '../data';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-mapping';
in.date = '150821'; 
in.index = '3';
fname1 = buildDataFileName(in);
load(fname1);

% ideally this should be an argument
fname2 = 'cluttered_box_map_field_pts';
load(fname2);

%% convert data

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
posesField = zeros(3,length(fieldPts));
posesField(1,:) = [fieldPts.x];
posesField(2,:) = [fieldPts.y];
[XField,bearingsField,pIdsField] = pose2BearingPoses(posesField,bearings);

% Z data
% Z is [NB,1]. Z{i} is [1,M]
ZTrain = obsArray(trainIds,bearingIds)'; ZTrain = ZTrain(:);

% Cleanup data
[XTrain,ZTrain,bearingsTrain,pIdsTrain] = cleanupDataForDRegress(XTrain,ZTrain,bearingsTrain,pIdsTrain);

%% save data
in.tag = 'exp11-loss-field-dreg-input';
fname = buildDataFileName(in);
save(fname,'sensor',...
    'XTrain','pIdsTrain','bearingsTrain','ZTrain','posesTrain','trainIds',...
    'XField','pIdsField','bearingsField','posesField');
