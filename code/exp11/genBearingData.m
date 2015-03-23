load processed_data_peta_240215

%%
pxId = 275;
data = pixelDataFromObsArray(obsArray,pxId);
ZTrain = data(trainPoseIds);
ZHold = data(holdPoseIds);
ZTest = data(testPoseIds);

% extract y-coordinate as state
XTrain = poses(2,trainPoseIds); XTrain = XTrain';
XHold = poses(2,holdPoseIds); XHold = XHold';
XTest = poses(2,testPoseIds); XTest = XTest';

lzr = laserClass(struct());

save(sprintf('mats/bearing_%d_data',pxId),'XTrain','ZTrain','XHold','ZHold','XTest','ZTest','lzr');
