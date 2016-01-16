% train model on design risk
debugFlag = false;

%% setup variables
% dataset
load('../src/data_gencal/data_gencal_1_train','dataset');

if debugFlag 
    fprintf('trainDes:nElements: %d.\n',length(dataset));
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
load('laser_class_object','laser');
laserModel = thrunLaserModel(struct('laser',laser));

%% optimize
% x = [pZero alpha beta]
fun = @(modelParams) modelObj(lossFn,dataset,laserModel,modelParams);
lb = [1 1 1]*eps;
ub = [1 0.5 1];
modelParams0 = [0.3 0.01 0.2];
% options = optimoptions('fmincon','Display','iter','MaxIter',100);
clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[]);

if debugFlag
    fprintf('trainObs:Computation took %.2fs.\n',toc(clockLocal));
end

%% save
fname = 'train_des_res';
save(fname,'laserModel','lb','ub','modelParams0','modelParamsOptim','objOptim','exitflag','output');
