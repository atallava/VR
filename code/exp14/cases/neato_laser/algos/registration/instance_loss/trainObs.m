% train model on observation risk

%% setup variables
dataset = load('../algo_registration/data_gencal/data_gencal_train');
lossFn = @lossObsThrunModel;

%% setup model
load('laser_class_object','laser');
laserModel = thrunLaserModel(struct('laser',laser));

%% optimize
% x = [pZero alpha beta]
fun = @(x) modelObjObs(x,laserModel,algosVars,lossFn);
lb = [1 1 1]*eps;
ub = [1 0.5 1];
modelParams0 = [0.3 0.01 0.2];
% options = optimoptions('fmincon','Display','iter','MaxIter',100);
clockLocal = tic();
[modelParamsOptim,objOptim,exitflag,output] = fmincon(fun,modelParams0,[],[],[],[],lb,ub,[]);
fprintf('trainBaseline:Computation took %.2fs.\n',toc(clockLocal));


