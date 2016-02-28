% load
% same data as npreg
fname = '../data/thrun_model_train_data_wide_corridor';
load(fname,'XTrain','ZTrain','sensor');
rangesNominalTrain = XTrain(:,1);

%% optimize
% x = [sigma lambda alpha]
fun = @(params) thrunModelNll(rangesNominalTrain,ZTrain,sensor,params);
lb = [1e-4 1e-2 1e-5];
ub = [0.5 20 1];
params0 = [0.05 2 0.6];
% modelParams0 = uniformSamplesInRange([lb; ub],1);
% options = optimoptions('fmincon','Display','iter','MaxIter',100);
clockLocal = tic();
[paramsOptim,objOptim,exitflag,output] = fmincon(fun,params0,[],[],[],[],lb,ub,[]);

fprintf('trainObs:Computation took %.2fs.\n',toc(clockLocal));

% [0.0229 0.9 0.8603] l-corridor
% [0.0331 1.0477 0.8575] wide corridor