% train model on verification risk
debugFlag = false;

%% setup variables
% dataset
datasetFilename = '../src/data_gencal/data_gencal_l_far_clutter';
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
% x = [pZero alpha beta]
fun = @(modelParams) modelObj(lossFn,dataset,laserModel,modelParams);
lb = [1 1 1]*0;
ub = [0.3 0.05 0.01];
modelParams0 = [0.1 0.01 0.005];
clockLocal = tic();
% [modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[]);
[modelParamsOptim,objOptim,exitflag,output] = patternsearch(fun,modelParams0,[],[],[],[],lb,ub,[]);

if debugFlag
    fprintf('trainObs:Computation took %.2fs.\n',toc(clockLocal));
end

%% save
fname = 'train_ver_res';
save(fname,'datasetFilename','algoParams','laserModel',...
    'lb','ub','modelParams0','modelParamsOptim','objOptim','exitflag','output');

