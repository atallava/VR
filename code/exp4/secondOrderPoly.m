function res = secondOrderPoly(weights,x)
if nargin == 0
    % if empty query, return the length of weights
    res = 10;
    return;
end
res = weights(1)+...
    weights(2)*x(:,1)+weights(3)*x(:,2)+weights(4)*x(:,3)+...
    weights(5)*x(:,1)*x(:,2)+weights(6)*x(:,1)*x(:,3)+weights(7)*x(:,2)*x(:,3)+...
    weights(8)*x(:,1)^2+weights(9)*x(:,2)^2+weights(10)*x(:,3)^2;

end

