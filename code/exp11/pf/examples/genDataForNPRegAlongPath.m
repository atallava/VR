% map 
fnameReadings = '../data/pf_readings_wide_corridor_short_traj';
load(fnameReadings,'poseHistory','map','sensor','dynamicMapList');

%% get poses
% check: pose of sensor or pose of robot?
NMax = 30;
nPosesTraj = size(poseHistory,2);
if nPosesTraj > NMax
    readingsIds = randsample(1:nPosesTraj,NMax);
else
    readingsIds = 1:nPosesTraj;
end
poses = poseHistory(:,readingsIds)';
N = size(poses,2);
M = 50;

%% specify sensor model
% laser gencal
load sim_sep6_1.mat
sensorModel = rsim;
% scrub hacks
sensorModel.setMap(map);
sensorModel.laser = laserClass(struct());
sensor = sensorModel.laser;
nBearings = sensorModel.laser.nBearings;
for i = 1:length(sensorModel.pxRegBundleArray)
    sensorModel.pxRegBundleArray(i).nBearings = nBearings;
end

%% simulate sensor readings
% get poses of dynamic objects
% for each state [x,y]
% specify the static and the dynamic map
% raycast in the static and the dynamic map
% figure out which bearings intersect dynamic obstacles
% half probability ranges are dynamic, half static

% simulate sensor readings
obsArray = cell(N,nBearings);
clockLocal = tic();
for i = 1:N
    readings = zeros(M,nBearings);
    staticMap = lineMap(map.objects);
    staticMapRanges = staticMap.raycast(poses(i,:),sensor.maxRange,sensor.bearings);
    
    % get dynamic map
    dynamicMap = dynamicMapList{readingsIds(i)};
    
    dynamicMapRanges = dynamicMap.raycast(poses(i,:),sensor.maxRange,sensor.bearings);
    dRanges = abs(staticMapRanges-dynamicMapRanges);
    dynamicHitBearings = dRanges > 1e-4; % arbitrary threshold
    
    sensorModel.setMap(staticMap);
    for j = 1:M/2
		readings(j,:) = sensorModel.simulate(poses(i,:)');
    end
    sensorModel.setMap(dynamicMap);
    for j = M/2+1:M
		readings(j,:) = sensorModel.simulate(poses(i,:)');
    end
        
	for j = 1:nBearings
		obsArray{i,j} = readings(:,j);
	end
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save to file
fname = '../data/npreg_obs_data_wide_corridor_along_path';
save(fname);

