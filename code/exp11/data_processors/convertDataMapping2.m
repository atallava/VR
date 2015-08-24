% convert sensor data to dreg format
% for sensor modeling
% in.pre = '../data';
% in.source = 'sim-laser-gencal';
% in.tag = 'exp11-mapping';
% in.date = '150819'; 
% in.index = '';
% fname = buildDataFileName(in);
% load(fname);

load processed_data_peta_240215

%% convert data
% hand-pick ids

holdIds = 3;
trainIds = [1 2 4];
testIds = 10;

% poses
posesTrain = poses(:,trainIds);
posesHold = poses(:,holdIds);
posesTest = poses(:,testIds);

% bearings
% can train on some bearings only
bearingIds = 1:360;
bearings = sensor.bearings(bearingIds); 

% bearing groups
B = length(bearings);
g = 2;
G = B/g;
bearingGroups = zeros(G,g);
oddIds = [0:G-1]*2+1;
evenIds = oddIds+1;
bearingGroups(:,1) = bearings(oddIds);
bearingGroups(:,2) = bearings(evenIds);
bearingGroupIds(:,1) = oddIds; bearingGroupIds(:,2) = evenIds;

%%
% bearing poses
% X is [NG,dimX]
[XTrain,bearingGroupsTrain,pIdsTrain] = pose2BearingPoses2(posesTrain,bearingGroups);
[XHold,bearingGroupsHold,pIdsHold] = pose2BearingPoses2(posesHold,bearingGroups);
[XTest,bearingGroupsTest,pIdsTest] = pose2BearingPoses2(posesTest,bearingGroups);

% Z data
% Z is [NG,1]. Z{i} is [2,M]
ZTrain = obsArray2Z2(obsArray,trainIds,bearingGroupIds);
ZHold = obsArray2Z2(obsArray,trainIds,bearingGroupIds);
ZTest = obsArray2Z2(obsArray,trainIds,bearingGroupIds); 

% Cleanup data
% trickier to deal with null data
% [XTrain,ZTrain,bearingGroupsTrain,pIdsTrain] = cleanupDataForDRegress2(XTrain,ZTrain,bearingGroupsTrain,pIdsTrain);
% [XHold,ZHold,bearingGroupsHold,pIdsHold] = cleanupDataForDRegress2(XHold,ZHold,bearingGroupsHold,pIdsHold);
% [XTest,ZTest,bearingGroupsTest,pIdsTest] = cleanupDataForDRegress2(XTest,ZTest,bearingGroupsTest,pIdsTest);

%% save data
in.tag = 'exp11-mapping-dreg2';
% fname = buildDataFileName(in);
fname = '../data/exp11_processed_data2_peta_240215.mat';
save(fname,'sensor',...
    'XTrain','pIdsTrain','bearingGroupsTrain','ZTrain','posesTrain','trainIds',...
    'XHold','pIdsHold','bearingGroupsHold','ZHold','posesHold','holdIds',...
    'XTest','pIdsTest','bearingGroupsTest','ZTest','posesTest','testIds');
