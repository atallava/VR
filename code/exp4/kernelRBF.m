function res = kernelRBF(x1,x2,kernelParams)
% RBF kernel centered about x1
% x1 is 1 x dimX
% x2 is n x dimX
% kernelParams has field ('gammma')
% res is 1 x n

if isfield(kernelParams,'gamma')
    gamma = kernelParams.gamma;
else
    gamma = 1.0;
end

if iscolumn(x1)
    x1 = x1';
end
n = size(x2,1);
res = zeros(1,n);
for i = 1:n
    d = norm(x1-x2(i,:));
    res(i) = exp(-gamma*d^2);
end
end

