% from reference, generate states and readings to be used for pf

%% load data of map and path
fnameRefTraj = '../data/pf_reference_traj';
load(fnameRefTraj,'traj');
fnameMap = '../data/l_corridor';
load(fnameMap,'map');

%% specify sensor model
% laser gencal
fnameSim = 'sim_sep6_1';
load(fnameSim,'rsim');
sensorModel = rsim;
% scrub hacks
sensorModel.laser = laserClass(struct());
sensor = sensorModel.laser;
nBearings = sensorModel.laser.nBearings;
for i = 1:length(sensorModel.pxRegBundleArray)
    sensorModel.pxRegBundleArray(i).nBearings = nBearings;
end

%% specify readings period
observationReadingPeriod = 1; % in s
motionTPeriod = 0.01; % in s

%% readings struct
% motion model parameters
load('../data/pf_motion_noise','etaV','etaW');

% dynamic supports
fnameDynSupp = [fnameMap '_dynamic_supports'];
load(fnameDynSupp,'supports');

% dynamic object parameters
fnameDynObj = '../data/dynamic_object';
load(fnameDynObj,'dynamicBBox');
minDynamicObjects = 5;
maxDynamicObjects = 10; % in each strip

% robot bounding box
fnameRobotBBox = '../data/robot_bbox';
load(fnameRobotBBox,'robotBBox');

numLaserReadings = floor(traj.getTrajectoryDuration/observationReadingPeriod)+1;
readings = struct('data',{},'type',{});
poseHistory = zeros(3,numLaserReadings);
tHistory = zeros(1,numLaserReadings);
dynamicMapList = cell(1,numLaserReadings);

pose = traj.poseArray(:,1);
poseHistory(:,1) = pose;
tHistory(1) = 0;
prevTime = 0;
count = 1;

% first laser reading
readings(count).type = 'observation';
% gen dynamic map
dynamicMap = genDynamicMap(map,supports,dynamicBBox,minDynamicObjects,maxDynamicObjects);
% set map for sensor
sensorModel.setMap(dynamicMap);
% log dynamic map
dynamicMapList{1} = dynamicMap;
% simulate observation
observationData.ranges = sensorModel.simulate(pose);
readings(count).data = observationData;
count = count+1;

clockLocal = tic();
for i = 2:numLaserReadings
	currentTime = observationReadingPeriod*(i-1);
	tHistory(i) = currentTime;
	
	% motion reading
	readings(count).type = 'motion';
	tArray = prevTime:motionTPeriod:(currentTime-motionTPeriod);
	[VArray,wArray] = traj.getControl(tArray);
    % interpolate controls
	dtArray = tArray(2:end)-tArray(1:end-1);
	dtArray = [dtArray motionTPeriod];
	motionData.VArray = VArray;
	motionData.wArray = wArray;
	motionData.dtArray = dtArray;
	readings(count).data = motionData;
	count = count+1;
    % forward simulate pose
	[VNoisy,wNoisy] = injectVelocityNoise(VArray,wArray,etaV,etaW);
	pose = integrateVelocityArray(pose,VNoisy,wNoisy,dtArray);
	poseHistory(:,i) = pose;
	
	% observation reading
	readings(count).type = 'observation';
    % gen dynamic map
    dynamicMap = genDynamicMap(map,supports,dynamicBBox,minDynamicObjects,maxDynamicObjects);
    % set map for sensor
    sensorModel.setMap(dynamicMap);
    % log dynamic map
    dynamicMapList{i} = dynamicMap;
    % simulate observation
	ranges = sensorModel.simulate(pose);
        
    observationData.ranges = ranges;
	readings(count).data = observationData;
	count = count+1;
    
    prevTime = currentTime;
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save to file
fnameSupport = [fnameMap '_support'];
load(fnameSupport,'support');

fname = '../data/pf_readings';
save(fname,'map','dynamicMapList','support',...
    'sensor','traj','poseHistory','tHistory','readings');
