%% initialize
load nsh_4227_corner_plank_map
SetupLidar;
hk = myHokuyo(lidar);

%% initialize
localizer = lineMapLocalizer(map.objects);
hkLaser = laserClass(struct('maxRange',5,'rangeRes',1e-3,'bearings',deg2rad(linspace(-120,120,682)),'nullReading',0,'Tsensor',eye(3)));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',hkLaser,'skip',5,'numIterations',300));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',hkLaser));
poseIn = [0 0 0]';

%% specify offset
offset = [0.1 0 0]'; 
poseIn = poseIn+offset;
ranges = hk.ranges;
vizer.viz(ranges,poseIn);

%% refine pose
[refinerStats,poseOut] = refiner.refine(ranges,poseIn);
vizer.viz(ranges,poseOut);
poseIn = poseOut;

%% wrap up
vizer.delete();
close all;
hk.shutdown();
DisconnectLidar();
