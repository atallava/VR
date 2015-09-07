% from reference, generate states and readings to be used for pf

%% load data of map and path
fname = 'pf_reference_traj';
load(fname);

%% specify sensor model
% laser gencal
load sim_sep6_1.mat
sensorModel = rsim;
% scrub hacks
sensorModel.laser = laserClass(struct());
sensor = sensorModel.laser;
nBearings = sensorModel.laser.nBearings;
for i = 1:length(sensorModel.pxRegBundleArray)
    sensorModel.pxRegBundleArray(i).nBearings = nBearings;
end
sensorModel.setMap(map);

%% specify readings period
observationReadingPeriod = 1; % in s
motionTPeriod = 0.01; % in s

%% create readings struct
load pf_motion_noise
sensorModel.setMap(map);
numLaserReadings = floor(traj.getTrajectoryDuration/observationReadingPeriod)+1;
readings = struct('data',{},'type',{});
poseHistory = zeros(3,numLaserReadings);
tHistory = zeros(1,numLaserReadings);

pose = traj.poseArray(:,1);
poseHistory(:,1) = pose;
tHistory(1) = 0;
prevTime = 0;
count = 1;

% first laser reading
readings(count).type = 'observation';
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
	dtArray = tArray(2:end)-tArray(1:end-1);
	dtArray = [dtArray motionTPeriod];
	motionData.VArray = VArray;
	motionData.wArray = wArray;
	motionData.dtArray = dtArray;
	readings(count).data = motionData;
	count = count+1;
	
	[VNoisy,wNoisy] = injectVelocityNoise(VArray,wArray,etaV,etaW);
	pose = integrateVelocityArray(pose,VNoisy,wNoisy,dtArray);
	poseHistory(:,i) = pose;
	
	% observation reading
	readings(count).type = 'observation';
	% set dynamic map in sensor model
	observationData.ranges = sensorModel.simulate(pose);
	readings(count).data = observationData;
	count = count+1;
    prevTime = currentTime;
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save to file
fname = 'pf_readings';
save(fname,'map','traj','poseHistory','tHistory','readings');
