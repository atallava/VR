load data/data_peta_230215
obsArray1 = fillObsArray(lzr,t_range_collection);
% reading 91 has too less data
for i = 1:length(90)
    poses1(:,i) = robotModel.laser.refPoseToLaserPose(poseHistory(:,i));
end

%%
load data/data_peta_240215
obsArray2 = fillObsArray(lzr,t_range_collection);
for i = 1:length(t_range_collection)
    poses2(:,i) = robotModel.laser.refPoseToLaserPose(poseHistory(:,i));
end

%%
obsArray = [obsArray1; obsArray2];
poses = [poses1 poses2];
%%
nTrain = ceil(0.6*size(poses,2));
nHold = ceil(0.2*size(poses,2));
trainPoseIds = randsample(1:size(poses,2),nTrain);
remaining = setdiff(1:size(poses,2),trainPoseIds);
holdPoseIds = randsample(remaining,nHold);
testPoseIds = setdiff(remaining,holdPoseIds);
%%
save('processed_data_peta_240215','obsArray','poses','trainPoseIds','testPoseIds');

%%
load 5720_corner_map
localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',laserClass(struct()),'skip',5,'numIterations',300));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',laserClass(struct())));

%%
obsId = 1;
for i = 1:size(poses,2)
    pose = poses(:,i);
    ranges = rangesFromObsArray(obsArray,i,obsId);
    [~,pose] = refiner.refine(ranges,pose);
    ri = rangeImage(struct('ranges',ranges)); 
    hf = ri.plotXvsY(pose);
    set(hf,'visible','off');
    ylim([0 5]); xlim([-3 3]);
    fname = sprintf('figs/loclzn/pose_%d.png',i);
    print('-dpng','-r72',fname);
end