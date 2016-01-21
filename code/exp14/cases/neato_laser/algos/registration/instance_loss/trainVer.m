% train model on verification risk
debugFlag = true;

%% setup variables
% dataset
datasetFilename = '../src/data_gencal/data_gencal_ver_trial_train';
load(datasetFilename,'dataset');

if debugFlag 
    fprintf('trainVer:nElements: %d.\n',length(dataset));
end

% algo params
load('../src/data/algo_param_eps_vector','eps0');
algoParams.maxErr = 0.05;
epsScale = 0.001;
algoParams.eps = eps0*epsScale;

% algo objective
algoObj = @registrationObjWrapper;
warning('off','laserPoseRefiner:refine:illData');
warning('off','lineMapLocalizer:refinePose:illData');

% loss function
lossFn = @(X,Y,model) lossVer(X,Y,model,algoObj,algoParams);

%% setup model
load('laser_class_object','laser');
laserModel = thrunLaserModel(struct('laser',laser));

%% optimize
% modelParams = [pZero alpha beta]
fun = @(modelParams) modelObj(lossFn,dataset,laserModel,modelParams);
lb = [1 1 1]*0;
ub = [0.3 0.05 0.01];
modelParams0 = [0.1 0.01 0.005];
logFilename = 'optim_log';

% specify solver and options
solverStr = 'patternsearch';
if strcmp(solverStr,'fmincon')
    options = optimoptions(solverStr);
    options.OutputFcn = @(x,optimValues,state) optimLog(x,optimValues,state,logFilename);
    solver = str2func(solverStr);
elseif strcmp(solverStr,'patternsearch')
    options = psoptimset();
    options.OutputFcn = @(optimvalues,options,flag) optimLog(optimvalues,options,flag,logFilename);
    solver = str2func(solverStr);
else
    error('Invalid solver string.');
end

clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = solver(fun,modelParams0,[],[],[],[],lb,ub,[],options);
tComp = toc(clockLocal);
if debugFlag
    fprintf('trainObs:Computation took %.2fs.\n',tComp);
end

%% save
fname = 'train_ver_trial';
save(fname,'datasetFilename','algoParams','laserModel',...
    'lb','ub','modelParams0','logFilename','options','solver',...
    'modelParamsOptim','objOptim','exitflag','output','tComp');

