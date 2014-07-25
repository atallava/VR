% optimize error wrt kernel parameters
clearAll;
load test_feature_seln

inputStruct.regClass = @pixelRegressorBundle; 
inputStruct.regClassInput = muPxRegBundle.inputStruct;
inputStruct.XTest = dp.XTest;
inputStruct.YTest = testPdfs.paramArray(:,1,:);
oldParams = muPxRegBundle.inputStruct.kernelParams;
err = errorOnKernelParams(inputStruct);

%% run optimizer
warning('off');
problem.objective = @(x) err.value(struct('h',x(1),'lambda',x(2)));
problem.x0 = [1 1e-6];
problem.Aineq = []; problem.bineq = [];
problem.Aeq = []; problem.beq = [];
problem.lb = zeros(size(problem.x0)); problem.ub = Inf(size(problem.x0));
problem.nonlcon = [];
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon','Algorithm','interior-point','Display','iter');
t1 = tic();
params = fmincon(problem);
fprintf('Computation took %fs.\n',toc(t1));
fprintf('Error with old kernel parameters: %f\n',err.value(oldParams));
fprintf('Error with optimized kernel parameters: %f\n',err.value(struct('h',params(1),'lambda',params(2))));
warning('on');