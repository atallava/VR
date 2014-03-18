function res = kernelInvPoseDist(x1,x2)
% x1, x2 are 3 x 1
% lambda1, lambda2 are scaling factors
lambda1 = 1;
lambda2 = 5;

res = lambda1/(1+lambda2*pose2D.poseNorm(x1,x2));
res = res^2;
end

