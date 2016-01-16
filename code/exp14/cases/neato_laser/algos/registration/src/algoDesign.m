% algo design on data
% load data
fnameData = 'data/data_gencal_2_train.mat';
load(fnameData,'dataset');
nElements = length(dataset);

%% max objective estimate
% assuming zero pose refinement
objVec = zeros(1,nElements);
for i = 1:nElements
    X = dataset(i).X;
    objVec(i) = pose2D.poseNorm(X.sensorPose,X.perturbedPose);
end
maxObjEst = mean(objVec);
fprintf('Maximum objective estimate: %.3f.\n',maxObjEst);

%% objective local minimum
warning('off','laserPoseRefiner:refine:illData');
warning('off','lineMapLocalizer:refinePose:illData');

fun = @(x) algoObjDataset(dataset,x);
params0 = [1 1]*1e-2;
lb = [1 1]*1e-6; % theoretically zero
ub = [1 1]*inf;
clockLocal = tic();
[paramsOptim,objOptim,exitflag,output] = fmincon(fun,params0,[],[],[],[],lb,ub);
tComp = toc(clockLocal);
fprintf('Computation took %.3fs.\n',tComp);
fprintf('Objective local minimum: %.3f.\n',objOptim);

%% min objective over samples
fnameSamples = 'data/algo_params_samples';
load(fnameSamples,'algoParamsSamples');
fprintf('Num algo params samples: %d.\n',length(algoParamsSamples));
objSamples = algoObjOverSamples(dataset,@algoObjDataset,algoParamsSamples);
[minObjSamples,minId] = min(objSamples);
fprintf('Min objective over samples: %.3f.\n',minObjSamples);

%% objective range
fprintf('Objective range estimate: %.3fs.\n',maxObjEst-objOptim);
fprintf('Objective range over samples: %.3fs\n',range(objSamples));

%% write to file
fnameW = 'data/algo_design_results';
save(fnameW,'fnameData','maxObjEst','paramsOptim','objOptim','exitflag','output',...
    'algoParamsSamples','objSamples','minObjSamples');