load data_sep6_micro_train

threshRanges(lzr);
obsArrayTrain = fillObsArray(lzr,t_range_collection);
poses = poseHistory;
trainPoseIds = 1:length(poseHistory);
%%
load data_sep6_micro_test

threshRanges(lzr);
obsArrayTest = fillObsArray(lzr,t_range_collection);

obsArray = [obsArrayTrain; obsArrayTest];
poses = [poses poseHistory];
testPoseIds = [1:length(poseHistory)]+trainPoseIds(end);

%%
load roomLineMap;
load processed_data_sep6
localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',100));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));
obsId = 1;
newPoses = [];
for i = 1:size(poses,2)
    ranges = rangesFromObsArray(obsArray,i,obsId);
    pose = poses(:,i);
    [~,pose] = refiner.refine(ranges,pose);
    newPoses(:,end+1) = pose;
%     vizer.viz(ranges,pose);
%     title(sprintf('%d',i));
%     set(vizer.hfig,'visible','off');
%     print(vizer.hfig,'-dpng','-r72',sprintf('images/registration_sep6/p%d.png',i));
end
