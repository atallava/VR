% train model on observation risk

%% setup variables
% dataset
dataset = load('../src/data_gencal/data_gencal_train');

% loss function
lossFn = @lossObsThrunModel;

%% setup model
load('laser_class_object','laser');
laserModel = thrunLaserModel(struct('laser',laser));

%% optimize
% x = [pZero alpha beta]
fun = @(modelParams) modelObj(lossFn,dataset,model,modelParams);
lb = [1 1 1]*eps;
ub = [1 0.5 1];
modelParams0 = [0.3 0.01 0.2];
% modelParams0 = uniformSamplesInRange([lb; ub],1);
% options = optimoptions('fmincon','Display','iter','MaxIter',100);
clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[]);
fprintf('trainObs:Computation took %.2fs.\n',toc(clockLocal));

%% save
fname = 'train_obs_res';
save(fname,'laserModel','lb','ub','modelParams0','modelParamsOptim','objOptim','exitflag','output');
