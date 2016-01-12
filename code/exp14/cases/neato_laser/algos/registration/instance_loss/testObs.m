% test model on observation risk
debugFlag = false;

%% setup variables
% dataset
load('../src/data_gencal/data_gencal_train','dataset');

if debugFlag 
    fprintf('testObs:nElements: %d.\n',length(dataset));
end

% loss function
lossFn = @lossObsThrunModel;

%% setup model
load('train_des_res','laserModel','modelParamsOptim');

%% evaluate
risk = modelObj(lossFn,dataset,laserModel,modelParamsOptim);
fprintf('Observation risk: %.2f.\n',risk);
