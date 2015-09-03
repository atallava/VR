% convert data for exp11
load parameters_150831;

minZ = Inf;
N = 200;
obsArray = cell(N,1);
poses = zeros(1,N);
throwIds = [];
for i = 1:N
    fname = sprintf('data_%03d',i);
    try
        data = parseData(fname);
    catch
        throwIds = [throwIds i];
        continue;
    end
    readings = [data.x];
    z = magicFactor*(readings-reading0);
    obsArray{i,1} = z;
    if min(z) < minZ
        minZ = min(z);
    end
    poses(i) = i/10; % poses in cm
end

poses(throwIds) = [];
obsArray(throwIds) = [];

%%
minRange = floor(minZ); % this could go below zero
maxRange = 20; % in cm
rangeRes = 0.1; 
sensor = struct('minRange',minRange,'maxRange',maxRange,'rangeRes',rangeRes,'bearings',0,'nBearings',1);

%%
N = length(poses);
frac = 0.6;
NTrain = ceil(frac*N);
NHold = ceil(0.5*(N-NTrain));
NTest = N-NTrain-NHold;
trainIds = randsample(1:N,NTrain);
holdIds = randsample(setdiff(1:N,trainIds),NHold);
testIds = setdiff(1:N,union(trainIds,holdIds));

%% save to file
in.pre = 'data/';
in.source = 'ascension-tracker';
in.tag = 'exp11-sensor-modeling';
in.date = '150831';
in.index = '';
fname = buildDataFileName(in);
save(fname,'N','sensor','obsArray','poses','trainIds','holdIds','testIds');

