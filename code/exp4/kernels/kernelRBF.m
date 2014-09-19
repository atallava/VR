function res = kernelRBF(x1,x2,kernelParams)
%KERNELRBF
%
% res = KERNELRBF(x1,x2,kernelParams)
% 
% x1           - 1 x dimX.
% x2           - n x dimX.
% kernelParams - struct with fields ('h','lambda'), kernel width. Default = 1.0 if
%                passed empty struct.
% 
% res          - 1 x n kernel values.

dimX = length(x1);
if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 1.0;
end

if isfield(kernelParams,'lambda')
    lambda = kernelParams.lambda;
else
    lambda = ones(1,dimX-1);
end

if iscolumn(x1)
    x1 = x1';
end
n = size(x2,1);
res = zeros(1,n);
for i = 1:n
    temp = [1 lambda].*(x1-x2(i,:));
    d = norm(temp);
    arg = -d^2/(2*h^2);
    res(i) = exp(arg);
end
end

