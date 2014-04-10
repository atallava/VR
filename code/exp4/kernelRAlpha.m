function res = kernelRAlpha(x1,x2,kernelParams)
% x1 is 1 x 2
% x2 is n x 2
% kernelParams has fields ('h','lambda')
% h is a scaling factor, the window size
% alpha is weighted lambda times wrt r
% res is 1 x n

if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 0.0724;
end
if isfield(kernelParams,'lambda')
    lambda = kernelParams.lambda;
else
    lambda = 0.01/deg2rad(10);
end

if iscolumn(x1)
    x1 = x1';
end
n = size(x2,1);
res = zeros(1,n);
for i = 1:n
    d = (x1(1)-x2(i,1))^2;%+lambda*angleDist(x1(2),x2(i,2))^2;
    d = sqrt(d);
    res(i) = 1/(1+d/h)^2;
end
end

