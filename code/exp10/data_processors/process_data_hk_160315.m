% training data
clearAll
load data_hk_train_160315
nPoses = size(poseHistory,2);
poses = poseHistory;
hkLaser = laserClass(struct('maxRange',5,'rangeRes',1e-3,'bearings',deg2rad(linspace(-120,120,682)),'nullReading',0,'Tsensor',eye(3)));
trainPoseIds = 1:nPoses;

%%
obsArrayTrain = cell(nPoses,hkLaser.nPixels);
for i = 1:nPoses
    for j = 1:hkLaser.nPixels
        ids = (i-1)*nObs+1:i*nObs;
        data = rangeHistory(ids,j);
        obsArrayTrain{i,j} = data;
    end
end

%% test data
load data_hk_test_160315
nPoses = size(poseHistory,2);
testPoseIds = trainPoseIds(end)+1:nPoses;
poses = [poses poseHistory];

%%
obsArrayTest = cell(nPoses,hkLaser.nPixels);
for i = 1:nPoses
    for j = 1:hkLaser.nPixels
        ids = (i-1)*nObs+1:i*nObs;
        data = rangeHistory(ids,j);
        obsArrayTest{i,j} = data;
    end
end
obsArray = [obsArrayTrain; obsArrayTest];

%% 
save('processed_data_hk_160315','obsArray','poses','trainPoseIds','testPoseIds','hkLaser');