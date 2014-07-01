clearAll;
load('map.mat','roomLineMap');
load test_refiner_data
load sample_sensor_data_1
% start pose

refiner = laserPoseRefiner(struct('localizer',localizer,'laser',laser,'numIterations',40,'skip',4));
vizRanges = vizRangesOnMap(struct('localizer',localizer,'laser',laser));

ranges = laserArray(2).ranges;
[success,startPose] = refiner.refine(ranges,[0.1;0.05;0]);
hf = vizRanges.viz(ranges,startPose);

%% test steady-state localization via laser
rob = playbackTool(tEncArray,encArray,tLaserArray,laserArray);
rState = robState(rob,'robot',startPose);
rob.play();
while ~rob.endedFlag
    pause(0.001);
end
ranges = laserArray(end).ranges;
pose = rState.pose;
hf1 = vizRanges.viz(ranges,pose); title('before scan matching.');
[success,pose] = refiner.refine(ranges,pose);
hf2 = vizRanges.viz(ranges,pose); title('after scan matching.');