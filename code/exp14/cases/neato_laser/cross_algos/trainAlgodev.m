% train a simulator via algodev risk

%% setup algos variables
algosVars = struct('dataReal',{},'algoObj',{},'paramsSamples',{});
count = 1;

% detection
algosVars(count).dataReal = load('algos/detection/data/data_real_hold.mat');
algosVars(count).algoObj = @detectionObjWrapper;
load('algos/detection/data/algo_params_samples.mat','algoParamsSamples');
algosVars(count).paramsSamples = algoParamsSamples;
count = count+1;

% registration
algosVars(count).dataReal = load('algos/registration/data_gencal/data_gencal_hold.mat');
algosVars(count).algoObj = @registrationObjWrapper;
load('algos/registration/data/algo_params_samples.mat','algoParamsSamples');
algosVars(count).paramsSamples = algoParamsSamples;

%% setup model
inputStructLaserModel = load('data/data_laser_model');
inputStructLaserModel.kernelParams = [];
laserModel = exp14LaserModel(inputStructLaserModel);
laserModel.debugFlag = true;

%% optimize
fun = @(x) modelObjAlgodev(x,laserModel,algosVars);
modelParams0 = [1 1].*1e-2;
lb = [1 1]*eps; % theoretically zero
ub = [1 1]*100;
clockLocal = tic();
modelParamsOptim = fmincon(fun,modelParams0,[],[],[],[],lb,ub);
fprintf('trainAlgodev:Computation took %.2fs.\n',toc(clockLocal));

