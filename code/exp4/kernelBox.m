function res = kernelBox(x1,x2,kernelParams)
% box kernel centered about x1
% x1 is 1 x dimX
% x2 is n x dimX
% kernelParams has fields ('h')
% res is 1 x n

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

