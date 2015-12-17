% train a simulator via algodev risk

%% setup algos variables

algosVars = struct('realData',{},'algoObj',{},'paramsSamples',{});
count = 1;

% detection
algosVars(count).realData = load('algos/detection/real_data.mat');
algosVars(count).algoObj = 
algosVars(count).paramsSamples = load('algos/detection/algo_params_samples.mat');
count = count+1;

% registration
algosVars(count).realData = load('algos/registration/real_data.mat');
algosVars(count).algoObj = 
algosVars(count).paramsSamples = load('algos/detection/algo_params_samples.mat');

%% setup model

%% optimize

