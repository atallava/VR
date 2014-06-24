clearAll;
load('map.mat','roomLineMap');
load test_refiner_data;
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',laser));
lPoseIn = laser.refPoseToLaserPose(poseIn);
ranges = roomLineMap.raycast(lPoseIn,laser.maxRange,laser.bearings);
t1 = tic();
[success,poseOut] = refiner.refine(ranges,poseIn);
fprintf('scan match took %fs\n',toc(t1));
lPoseOut = laser.refPoseToLaserPose(poseOut);
hf1 = vizRealRanges(localizer,ranges,lPoseOut); title('lPoseOut');
hf2 = vizRealRanges(localizer,ranges,lPoseIn); title('lPoseIn');

