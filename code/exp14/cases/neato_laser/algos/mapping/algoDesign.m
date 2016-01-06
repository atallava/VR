% algo design on data
% load data
fnameData = 'data_gencal/data_gencal.mat';
data = load(fnameData);
nData = length(data.X);

%% max objective estimate
% maximum in theory
maxObjEst = 0;
fprintf('Maximum objective estimate: %.2f.\n',maxObjEst);

%% objective local minimum
fun = @(x) algoObjParamsVec(data,x);
params0 = [0.01,0.8];
lb = [0.005 0.5]; % theoretically zero
ub = [0.08 1];
clockLocal = tic();
[paramsOptim,objOptim,exitflag,output] = fmincon(fun,params0,[],[],[],[],lb,ub);
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