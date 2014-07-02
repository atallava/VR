function res = kernelRBF(x1,x2,kernelParams)
%KERNELRBF
%
% res = KERNELRBF(x1,x2,kernelParams)
% 
% x1           - 1 x dimX.
% x2           - n x dimX.
% kernelParams - struct with fields ('h'), kernel width. Default = 1.0 if
%                passed empty struct.
% 
% res          - 1 x n kernel values.

if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 1.0;
end

if iscolumn(x1)
    x1 = x1';
end
n = size(x2,1);
res = zeros(1,n);
for i = 1:n
    d = norm(x1-x2(i,:));
    res(i) = exp(-(d/h)^2);
end
end

