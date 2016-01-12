% test model on design risk
debugFlag = true;

%% setup variables
% dataset
load('../src/data_gencal/data_gencal_hold','dataset');

if debugFlag 
    fprintf('testVer:nElements: %d.\n',length(dataset));
end

% algo params samples
load('../src/data/algo_params_samples','algoParamsSamples');

% algo objective
algoObj = @registrationObjWrapper;
warning('off','laserPoseRefiner:refine:illData');
warning('off','lineMapLocalizer:refinePose:illData');

% loss function
lossFn = @(X,Y,model) lossDes(X,Y,model,algoObj,algoParamsSamples);

%% setup model
load('train_des_res','laserModel','modelParamsOptim');

%% evaluate
clockLocal = tic();
risk = modelObj(lossFn,dataset,laserModel,modelParamsOptim);
tComp = toc(clockLocal);
fprintf('Design risk: %.2f.\n',risk);

if debugFlag
    fprintf('testDes:Computation time: %.2fs.\n',tComp);
end
