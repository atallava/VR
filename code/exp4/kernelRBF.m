function res = kernelRBF(x1,x2)
% RBF kernel centered about x1

gamma = 2.0;
dist = norm(x1-x2);
res = exp(-gamma*dist^2);
end

