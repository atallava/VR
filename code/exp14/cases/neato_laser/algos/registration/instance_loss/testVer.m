% test model on verification risk
debugFlag = false;

%% setup variables
% dataset
load('../src/data_gencal/data_gencal_hold','dataset');

if debugFlag 
    fprintf('testVer:nElements: %d.\n',length(dataset));
end

% algo params
load('train_ver_res','algoParams');

% algo objective
algoObj = @registrationObjWrapper;
warning('off','laserPoseRefiner:refine:illData');
warning('off','lineMapLocalizer:refinePose:illData');

% loss function
lossFn = @(X,Y,model) lossVer(X,Y,model,algoObj,algoParams);

%% setup model
load('train_des_res','laserModel','modelParamsOptim');

%% evaluate
[risk,losses] = modelObj(lossFn,dataset,laserModel,modelParamsOptim);
fprintf('Verification risk: %.4f. std: %.4f. \n',risk,std(losses));
