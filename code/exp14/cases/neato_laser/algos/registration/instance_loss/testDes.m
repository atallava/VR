% test model on design risk
debugFlag = false;

%% setup variables
% dataset
load('../src/data/data_gencal_1_hold','dataset');

if debugFlag 
    fprintf('testDes:nElements: %d.\n',length(dataset));
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
[risk,losses] = modelObj(lossFn,dataset,laserModel,modelParamsOptim);
fprintf('Design risk: %.4f. std: %.4f. \n',risk,std(losses));
tComp = toc(clockLocal);

if debugFlag
    fprintf('testDes:Computation time: %.2fs.\n',tComp);
end
