function res = kernelPose(x1,x2,kernelParams)
% x1 is 1 x dimX
% x2 is n x dimX
% kernelParams has fields ('h')
% res is 1 x n

if isfield(kernelParams,'h')
    h = kernelParams.h;
else
    h = 0.05;
end

if iscolumn(x1)
    x1 = x1';
end
n = size(x2,1);
res = zeros(1,n);
for i = 1:n
    d = pose2D.poseNorm(x1,x2(i,:));
    res(i) = 1/(1+d/h)^2;
end
end

