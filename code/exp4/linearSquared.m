function res = linearSquared(weights,x)
if nargin == 0
    res = 4;
    return;
end

res = weights(1)+weights(2)*x(:,1)+weights(3)*x(:,2)+weights(4)*x(:,3);
res = res.^2;
end

