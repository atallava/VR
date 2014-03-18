function res = kernelRAlpha(x1,x2)
% x1,x2 are 2 x 1
% lambda1, lambda2 are scaling factors
lambda1 = 1;
lambda2 = 5;
% alpha is weighted lambda3 times wrt r
lambda3 = 0.01/deg2rad(10);

d = (x1(1)-x2(1))^2+lambda3*angleDist(x1(2),x2(2))^2;
res = lambda1/(1+lambda2*d);
res = res^2;
end

