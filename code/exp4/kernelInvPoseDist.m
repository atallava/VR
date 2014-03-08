function res = kernelInvPoseDist(x1,x2)
% x1, x2 are 3 x 1
alpha = 1;
res = 1/(1+alpha*pose2D.poseNorm(x1,x2));
res = res^2;
end

