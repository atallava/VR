% train model on observation risk

%% setup variables
% dataset
dataset = load('../src/data_gencal/data_gencal_train');

% algo params
load('../src/data/algo_param_eps_vector','eps0');
algoParams.maxErr = 0.1;
epsScale = 0.01;
algoParams.eps = ep0*epsScale;

% loss function
lossFn = @(X,Y,model) lossVer(X,Y,model,algoParams);

%% setup model
load('laser_class_object','laser');
laserModel = thrunLaserModel(struct('laser',laser));

%% optimize
% x = [pZero alpha beta]
fun = @(modelParams) modelObj(lossFn,dataset,model,modelParams);
lb = [1 1 1]*eps;
ub = [1 0.5 1];
modelParams0 = [0.3 0.01 0.2];
% options = optimoptions('fmincon','Display','iter','MaxIter',100);
clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[]);
fprintf('trainVer:Computation took %.2fs.\n',toc(clockLocal));

%% save
fname = 'train_ver_res';
save(fname,'algoParams','laserModel','lb','ub','modelParams0','modelParamsOptim','objOptim','exitflag','output');

