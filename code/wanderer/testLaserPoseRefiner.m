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
vizRanges = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));
hf1 = vizRanges.viz(localizer,ranges,lPoseOut); title('lPoseOut');
hf2 = vizRanges.viz(localizer,ranges,lPoseIn); title('lPoseIn');

