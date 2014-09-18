function res = fn1(inputStruct)
% given inputStruct, return optimal parameters and duration.
err = errorOnKernelParams(inputStruct);
t1 = tic();
params = optimizeKernelParamsFn(err);
duration = toc(t1);
res.params = params;
res.error = err.value(struct('h',params(1),'lambda',params(2)));
res.duration = duration;
end

