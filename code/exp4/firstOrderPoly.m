function res = firstOrderPoly(weights,x)
if nargin == 0
    res = 4;
    return;
end

if ~isrow(weights)
    weights = weights';
end
res = bsxfun(@times,x,weights(2:end));
res = sum(res,2);
res = res+weights(1);
end

