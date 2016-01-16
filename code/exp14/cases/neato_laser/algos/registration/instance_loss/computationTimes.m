% time for computation
% building blocks
timeThrunModelPredictionPerInstance = 0.06; % estimated upper bound
timeThrunModelNllPerInstance = 0.04;
timeAlgoObj = 0.15; % estimated avg

%% variables
nElements = 90;
nInstancesPerElement = 1;
nAlgoParamsSamples = 20;

%% obs
timeLossObs = nInstancesPerElement*timeThrunModelNllPerInstance;
timeRiskObs = nElements*timeLossObs;

%% ver
timeLossVer = 2*nInstancesPerElement*timeAlgoObj+nInstancesPerElement*timeThrunModelPredictionPerInstance;
timeRiskVer = nElements*timeLossVer;

%% des
timeLossDes = nAlgoParamsSamples*timeLossVer;
timeRiskDes = nElements*timeLossDes;

%% save
save('computation_times','timeLossObs','timeRiskObs',...
    'timeLossVer','timeRiskVer','timeLossDes','timeRiskDes');