function res = kernelInvPoseDist(x1,x2)
% x1, x2 are 3 x 1
% lambda1 is a scaling factor
lambda1 = 5;

res = 1/(1+lambda1*pose2D.poseNorm(x1,x2));
res = res^2;
end

