function res = firstOrderPoly(weights,x)
if nargin == 0
    res = 4;
    return;
end

if ~isrow(weights)
    weights = weights';
end
res = bsxfun(@times,x,weights(1:end-1));
res = sum(res,2);
res = res+weights(end);
end

