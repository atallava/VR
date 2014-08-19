load application_test_data
load ../mats/roomLineMap
rsim = load('full_predictor_mar27_1');
rsim = rsim.rsim; rsim.setMap(map);
rpool = load('full_predictor_mar27_4');
rpool = rpool.rsim; rpool.setMap(map);
rlocal = load('full_predictor_mar27_5');
rlocal = rlocal.rsim; rlocal.setMap(map);
localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'numIterations',200));
vizer = vizRangesOnMap(struct('localizer',localizer));
pose = data(4).pose;
poseIn = pose+patternSet(:,10);

%%
warning('off');
r0 = data(4).ranges(10,:); 
r1 = rsim.simulate(pose);
r2 = rpool.simulate(pose);
r3 = rlocal.simulate(pose);
warning('on');