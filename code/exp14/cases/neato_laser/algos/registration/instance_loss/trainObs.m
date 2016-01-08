% train model on observation risk
debugFlag = false;

%% setup variables
% dataset
load('../src/data_gencal/data_gencal_train','dataset');

if debugFlag 
    fprintf('trainObs:nElements: %d.\n',length(dataset));
end

% loss function
lossFn = @lossObsThrunModel;

%% setup model
load('laser_class_object','laser');
laserModel = thrunLaserModel(struct('laser',laser));

%% optimize
% x = [pZero alpha beta]
fun = @(modelParams) modelObj(lossFn,dataset,laserModel,modelParams);
lb = [1 1 1]*eps;
ub = [1 0.5 1];
modelParams0 = [0.3 0.01 0.2];
% modelParams0 = uniformSamplesInRange([lb; ub],1);
% options = optimoptions('fmincon','Display','iter','MaxIter',100);
clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[]);

if debugFlag
    fprintf('trainObs:Computation took %.2fs.\n',toc(clockLocal));
end

%% save
fname = 'train_obs_res';
save(fname,'laserModel','lb','ub','modelParams0','modelParamsOptim','objOptim','exitflag','output');
