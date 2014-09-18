function res = fn2(inputStruct)
% given inputStruct, return results for np and lwl
inputStruct.kernelFn = @nonParametricRegressor;
resNp = fn1(inputStruct);
inputStruct.kernelFn = @locallyWeightedLinearRegressor;
resLwl = fn1(inputStruct);
res.np = resNp;
res.lwl = resLwl;
end

