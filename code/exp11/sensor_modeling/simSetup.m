% specify environment
load roomLineMap;
load roomLineMapSupport;
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

%% get training and test poses
% check: pose of sensor or pose of robot?
N = 1000;
poses = uniformSamplesOnSupport(support,map,bBox,N);
NTrain = ceil(0.6*N);
NValdn = ceil(0.5*(N-NTrain));
NTest = N-NTrain-NValdn;
trainIds = randsample(1:N,NTrain);
validnIds = randsample(setdiff(1:N,trainIds),NValdn);
testIds = setdiff(1:N,union(trainIds,validnIds));
M = 1000;

% specify sensor model
load sim_sep6_1.mat
rsim.setMap(map);
nBearings = rsim.laser.nBearings;
sensorModel = @rsim;

% simulate sensor readings
obsArray = cell(N,nBearings);
for i = 1:N
	readings = zeros(M,nBearings);
	for j = 1:M
		readings(j,:) = sensorModel.simulate(poses(:,i));
	end
	for j = 1:nBearings
		obsArray{i,j} = readings(:,j);
	end
end

% save to file