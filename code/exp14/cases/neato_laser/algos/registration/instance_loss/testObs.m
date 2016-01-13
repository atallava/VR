% test model on observation risk
debugFlag = false;

%% setup variables
% dataset
load('../src/data_gencal/data_gencal_hold','dataset');

if debugFlag 
    fprintf('testObs:nElements: %d.\n',length(dataset));
end

% loss function
lossFn = @lossObsThrunModel;

%% setup model
load('train_ver_res','laserModel','modelParamsOptim');

%% evaluate
[risk,losses] = modelObj(lossFn,dataset,laserModel,modelParamsOptim);
fprintf('Observation risk: %.4f. std: %.4f. \n',risk,std(losses));
