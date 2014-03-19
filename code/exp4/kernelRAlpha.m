function res = kernelRAlpha(x1,x2)
% x1,x2 are 2 x 1
% h is a scaling factor, the window size
h = 0.0724;
% alpha is weighted lambda times wrt r
lambda = 0.01/deg2rad(10);

d = (x1(1)-x2(1))^2+lambda*angleDist(x1(2),x2(2))^2;
d = sqrt(d);
res = 1/(1+d/h);
res = res^2;
end

