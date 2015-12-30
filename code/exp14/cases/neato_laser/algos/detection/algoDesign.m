% algo design on data
% load data
fnameData = 'data/data_real_train.mat';
data = load(fnameData);
nData = length(data.X);

%% max objective estimate
% zero correct detections
maxObjEst = 0;
fprintf('Maximum objective estimate: %.2f.\n',maxObjEst);

%% objective local minimum
fun = @(x) algoObjParamsVec(data,x);
params0 = [1 1e-2];
lb = [1 eps];
ub = [20 inf];
intCon = 1; % nMin is integer
clockLocal = tic();
[paramsOptim,objOptim,exitflag,output] = ga(fun,2,[],[],[],[],lb,ub,[],intCon);
tComp = toc(clockLocal);
fprintf('Computation took %.2fs.\n',tComp);
fprintf('Objective local minimum: %.2f.\n',objOptim);

%% min objective over samples
fnameSamples = 'data/algo_params_samples';
load(fnameSamples,'algoParamsSamples');
fprintf('Num algo params samples: %d.\n',length(algoParamsSamples));
objSamples = algoObjOverSamples(data,@algoObj,algoParamsSamples);
[minObjSamples,minId] = min(objSamples);
fprintf('Min objective over samples: %.2f.\n',minObjSamples);

%% objective range
fprintf('Objective range estimate: %.2fs.\n',maxObjEst-objOptim);
fprintf('Objective range over samples: %.2fs\n',range(objSamples));

%% write to file
fnameW = 'data/algo_design_results';
save(fnameW,'fnameData','maxObjEst','paramsOptim','objOptim','exitflag','output',...
    'algoParamsSamples','objSamples','minObjSamples');