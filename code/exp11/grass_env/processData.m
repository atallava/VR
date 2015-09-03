fname = 'grass_om';
load(fname);
obsArray = fillObsArray(lzr,t_range_collection);
poses = zeros(size(poseHistory));
for i = 1:size(poses,2);
	poses(:,i) = robotModel.laser.refPoseToLaserPose(poseHistory(:,i));
end

N = size(poses,2);
frac = 0.7;
NTrain = ceil(frac*N);
trainIds = randsample(1:N,NTrain);
testIds = setdiff(1:N,trainIds);
sensor = laserClass(struct());

%%
save('data_150903','poses','obsArray','sensor',...
	'trainIds','testIds');


