load data_sep6_micro_train

threshRanges(lzr);

lzr.log(logical(flag)) = []; 
obsArrayTrain = fillObsArray(lzr,t_range_collection);
poses = poseHistory;
trainPoseIds = 1:length(poseHistory);
%%
load data_sep6_micro_test

threshRanges(lzr);
lzr.log(logical(flag)) = []; 
obsArrayTest = fillObsArray(lzr,t_range_collection);

obsArray = [obsArrayTrain; obsArrayTest];
poses = [poses poseHistory];
testPoseIds = [1:length(poseHistory)]+trainPoseIds(end);

%% correct poses
% poseHistory is robot's pose. simulator takes sensor pose.
load roomLineMap;
load processed_data_sep6
localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',100));
vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser));
obsId = 1;
newPoses = [];
for i = 1:size(poses,2)
    ranges = rangesFromObsArray(obsArray,i,obsId);
    pose = poses(:,i);
    [pose,~] = refiner.refine(ranges,pose);
    newPoses(:,end+1) = robotModel.laser.refPoseToLaserPose(pose);
%     vizer.viz(ranges,pose);
%     title(sprintf('%d',i));
%     set(vizer.hfig,'visible','off');
%     print(vizer.hfig,'-dpng','-r72',sprintf('figs/registration_sep6/p%d.png',i));
end

%% some training points are bad, because communication with matlab had slowed down 
% detect those 
tEncArray = enc.tArray-enc.tArray(1);
nuq = zeros(1,100);
for i = 31%1:100
	ts = t_range_collection(i).start-lzr.tArray(1);
	te = t_range_collection(i).end-lzr.tArray(1);
	ids = find(tEncArray > ts & tEncArray <= te);
	vec = [enc.log(ids).left];
	nuq(i) = length(unique(vec));
end

%% conclusion: poses [28,29,31,42] have jumps
% of these, the jump in 42 seems like noise, a jump of one value.
% the rest of the poses are being culled from processed_data
badIds = [28 29 31];
obsArray(badIds,:) = [];
poses(:,badIds) = [];
trainPoseIds(98:100) = [];
testPoseIds = testPoseIds-3;
save('processed_data_sep6','obsArray','poses','trainPoseIds','testPoseIds');

