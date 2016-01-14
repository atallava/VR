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
[risk,losses] = modelRisk(lossFn,dataset,laserModel);
fprintf('Observation risk: %.4f. std(losses): %.4f. \n',risk,std(losses));
