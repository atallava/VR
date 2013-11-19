function [vals,ids] = getClosest(vec,x)
%get closest values to x in vec, return the values and the ids
%both are rows or column vectors
if ~isrow(vec)
    vec = vec';
end
if isrow(x)
    x = x';
end

M = abs(bsxfun(@minus, repmat(vec,numel(x),1), x));
[~, ids] = min(M,[],2); 
vals = vec(ids);

end

