clearAll
load data_milli_160215_train
obsArrayTrain = fillObsArray(lzr,t_range_collection);
poses = [];
for i = 1:size(poseHistory,2)
	poses(:,end+1) = robotModel.laser.refPoseToLaserPose(poseHistory(:,i));
end
trainPoseIds = 1:length(poseHistory);

%%
load data_milli_160215_test
obsArrayTest = fillObsArray(lzr,t_range_collection);
testPoseIds = 1:length(poseHistory)+trainPoseIds(end);
obsArray = [obsArrayTrain; obsArrayTest];
for i = 1:size(poseHistory,2)
	poses(:,end+1) = robotModel.laser.refPoseToLaserPose(poseHistory(:,i));
end

%%
save('processed_data_milli_160215','obsArray','poses','trainPoseIds','testPoseIds');