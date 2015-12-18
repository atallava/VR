% train a simulator via algodev risk

%% setup algos variables
algosVars = struct('dataReal',{},'algoObj',{},'paramsSamples',{});
count = 1;

% detection
algosVars(count).dataReal = load('algos/detection/data_real_train.mat');
algosVars(count).algoObj = @detectionObjWrapper;
algosVars(count).paramsSamples = load('algos/detection/algo_params_samples.mat');
count = count+1;

% registration
algosVars(count).dataReal = load('algos/registration/data_real_train.mat');
algosVars(count).algoObj = @registrationObjWrapper;
algosVars(count).paramsSamples = load('algos/detection/algo_params_samples.mat');

%% setup model

%% optimize

