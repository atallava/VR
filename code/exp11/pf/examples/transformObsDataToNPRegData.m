% convert obs data to npreg format
fname = '../data/npreg_obs_data_wide_corridor';
load(fname,'map','sensor','poses','obsArray');

%% convert data
% poses

% can train on some bearings only
bearingIds = 1:360;
bearings = sensor.bearings(bearingIds); 

% bearing features
% X is [NB,d]
[XTrain,bearingsTrain,pIdsTrain] = pose2BearingFeatures(poses,bearings,map,sensor); 

% Z data
% Z is [NB,1]. Z{i} is [1,M]
ZTrain = obsArray'; ZTrain = ZTrain(:);

% Cleanup data
[XTrain,ZTrain,bearingsTrain,pIdsTrain] = cleanupDataForDRegress(XTrain,ZTrain,bearingsTrain,pIdsTrain);

%% save data
fname = '../data/npreg_train_data_wide_corridor';
save(fname);