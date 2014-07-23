% optimize error wrt kernel parameters
clearAll;
load('../mats/full_predictor_mar27_5.mat');

inputStruct.regClass = @pixelRegressorBundle; 
inputStruct.regClassInput = muPxRegBundle.inputStruct;
%inputStruct.regClassInput = struct('XTrain',muPxRegBundle.XTrain,'YTrain',muPxRegBundle.YTrain,'poolOption',muPxRegBundle.poolOption,'inputPoseTransf', muPxRegBundle.inputPoseTransf, ...
%    'regClass',muPxRegBundle.regClass,'XSpaceSwitch',muPxRegBundle.regressorArray{1}.XSpaceSwitch,'kernelFn',muPxRegBundle.regressorArray{1}.kernelFn);
inputStruct.XTest = dp.XTest;
inputStruct.YTest = testPdfs.paramArray(:,1,:);
oldH = muPxRegBundle.regressorArray{1}.kernelParams.h;
err = errorOnKernelParams(inputStruct);

%% run optimizer
warning('off');
problem.objective = @(x) err.value(struct('h',x));
problem.x0 = 0.01;
problem.Aineq = []; problem.bineq = [];
problem.Aeq = []; problem.beq = [];
problem.lb = 0; problem.ub = Inf;
problem.nonlcon = [];
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon','Algorithm','interior-point','Display','iter');
t1 = tic();
h = fmincon(problem);
fprintf('Computation took %fs.\n',toc(t1));
fprintf('Error with old kernel parameters: %f\n',err.value(struct('h',oldH)));
fprintf('Error with optimized kernel parameters: %f\n',err.value(struct('h',h)));
warning('on');