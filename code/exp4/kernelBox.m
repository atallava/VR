function res = kernelBox(x1,x2,kernelParams)
%KERNELBOX 
% Written to work with pdist2.
%
% res = KERNELBOX(x1,x2,kernelParams)
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
    res(i) = norm(x1-x2(i,:)) <= h/2;
end
res = res*1/h;
end

