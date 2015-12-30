% train a simulator via baseline risk

%% setup algos variables
algosVars = struct('dataReal',{},'algoObj',{},'paramsSamples',{});
count = 1;

% detection
algosVars(count).dataReal = load('algos/detection/data_real_train.mat');
count = count+1;

% registration
algosVars(count).dataReal = load('algos/registration/data_gencal/data_gencal_train.mat');

%% setup model
inputStructLaserModel = load('data/data_laser_model');
inputStructLaserModel.kernelParams = [];
laserModel = exp14LaserModel(inputStructLaserModel);
laserModel.debugFlag = true;

%% optimize
fun = @(x) modelObjBaseline(x,laserModel,algosVars);
modelParams0 = [1 1].*1e-2;
lb = [1 1]*eps; % theoretically zero
ub = [1 1]*inf;
options = optimoptions('fmincon','Display','iter','MaxIter',10);
clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[],options);
fprintf('trainBaseline:Computation took %.2fs.\n',toc(clockLocal));
