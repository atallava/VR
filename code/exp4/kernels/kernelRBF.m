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

temp = bsxfun(@minus,x2,x1);
temp = bsxfun(@times,temp,[1 lambda]);
temp = sqrt(sum(temp.^2,2));
if iscolumn(temp) 
    temp = temp';
end
temp = -temp.^2/(2*h^2);
res = exp(temp);
end

