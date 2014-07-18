function res = kernelEpanechnikov(x1,x2,kernelParams)
%KERNELEPANECHNIKOV 
%
% res = KERNELEPANECHNIKOV(x1,x2,kernelParams)
% 
% x1           - 1 x dimX.
% x2           - n x dimX.
% kernelParams - struct with fields ('h'), kernel width. Default = 1.0 if
%                passed empty struct.
% 
% res          - 1 x n kernel values

if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 1.0;
end

if iscolumn(x1)
    x1 = x1';
end
res = bsxfun(@minus,x2,x1);
res = sum(res.^2,2)/h^2;
flag = res < 1;
res(flag) = 0.75*(1-res(flag));
res(~flag) = 0;
res = res';
end