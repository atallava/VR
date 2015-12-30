% algo design on data
% load data
fnameData = 'data_gencal/data_gencal_train.mat';
data = load(fnameData);
nData = length(data.X);

%% max objective estimate
% assuming zero pose refinement
objVec = zeros(1,nData);
for i = 1:nData
    objVec(i) = pose2D.poseNorm(data.X(i).sensorPose,data.X(i).perturbedPose);
end
maxObjEst = mean(objVec);
fprintf('Maximum objective estimate: %.2f.\n',maxObjEst);

%% objective local minimum
fun = @(x) algoObjParamsVec(data,x);
params0 = [1 1]*1e-2;
lb = [1 1]*eps; % theoretically zero
ub = [1 1]*inf;
clockLocal = tic();
[paramsOptim,objOptim,exitflag,output] = fmincon(fun,params0,[],[],[],[],lb,ub);
tComp = toc(clockLocal);
fprintf('Computation took %.2fs.\n',tComp);
fprintf('Objective local minimum: %.2f.\n',objOptim);

%% min objective over samples
fnameSamples = 'algo_params_samples';
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