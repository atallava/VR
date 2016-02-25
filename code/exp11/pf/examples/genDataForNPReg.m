% map 
fnameMap = '../data/l_corridor';
load(fnameMap);
fnameSupport = [fnameMap '_support'];
load(fnameSupport);

% robot bounding box
fnameRobotBBox = '../data/robot_bbox';
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

%% get training and test poses
% check: pose of sensor or pose of robot?
N = 30;
poses = uniformSamplesOnSupport(map,support,bBox,N);
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

% dynamic supports
fnameDynSupp = [fnameMap '_dynamic_supports'];
load(fnameDynSupp,'supports');

% dynamic object parameters
fnameDynObj = '../data/dynamic_object';
load(fnameDynObj,'dynamicBBox');
minDynamicObjects = 5;
maxDynamicObjects = 10; % in each strip
dynamicMapList = cell(1,N);

% simulate sensor readings
obsArray = cell(N,nBearings);
clockLocal = tic();
for i = 1:N
	readings = zeros(M,nBearings);
    staticMap = lineMap(map.objects);
    staticMapRanges = staticMap.raycast(poses(i,:),sensor.maxRange,sensor.bearings);
    
    % gen dynamic map
    dynamicMap = genDynamicMap(map,supports,dynamicBBox,minDynamicObjects,maxDynamicObjects);
    dynamicMapList{i} = dynamicMap;
    
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
fname = '../data/npreg_train_data';
save(fname,'fNameMap','map','bBox',...
    'N','M','poses','trainIds','holdIds','testIds',...
    'dynamicBBox','minDynamicObjects','maxDynamicObjects','dynamicPosesList',...
    'sensorModel','sensor','obsArray');

