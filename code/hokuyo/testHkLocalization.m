%%
load nsh_4227_corner_map
SetupLidar;
hk = myHokuyo(lidar);

%%
localizer = lineMapLocalizer(map.objects);
hkLaser = laserClass(struct('maxRange',5,'rangeRes',1e-3,'bearings',deg2rad(linspace(-120,120,682)),'nullReading',0,'Tsensor',eye(3)));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',hkLaser,'skip',5,'numIterations',300));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',hkLaser));

%%
%poseIn = [1 0.6 pi]';
poseIn = poseOut;
poseIn = poseIn+[0.02 0 deg2rad(0)]';
ranges = hk.ranges;
vizer.viz(ranges,poseIn);

%%
[refinerStats,poseOut] = refiner.refine(ranges,poseIn);
vizer.viz(ranges,poseOut);

%%
hk.shutdown();

