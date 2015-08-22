% specify environment
fNameMap = 'nsh3_corridor';
load(fNameMap);
fNameSupport = [fNameMap '_support'];
load(fNameSupport);
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

%% get training and test poses
% check: pose of sensor or pose of robot?
N = 300;
poses = uniformSamplesOnSupport(support,map,bBox,N);
NTrain = ceil(0.6*N);
NHold = ceil(0.5*(N-NTrain));
NTest = N-NTrain-NHold;
trainIds = randsample(1:N,NTrain);
holdIds = randsample(setdiff(1:N,trainIds),NHold);
testIds = setdiff(1:N,union(trainIds,holdIds));
M = 100;

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

% simulate sensor readings
obsArray = cell(N,nBearings);
clockLocal = tic();
for i = 1:N
	readings = zeros(M,nBearings);
	for j = 1:M
		readings(j,:) = sensorModel.simulate(poses(:,i));
	end
	for j = 1:nBearings
		obsArray{i,j} = readings(:,j);
	end
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save to file
in.pre = [exp11Path '/data'];
in.source = 'sim-laser-gencal';
% in.tag = 'exp11-sensor-modeling';
in.tag = 'exp11-mapping';
in.date = yymmddDate();
in.index = '2';
fname = buildDataFileName(in);
save(fname,'fNameMap','map','support','sensor','sensorModel','N','poses','obsArray','trainIds','holdIds','testIds');