function res = ranges2Histogram(ranges,xcenters)
%RANGES2HISTOGRAM 
% 
% res = RANGES2HISTOGRAM(ranges,laser)
% 
% ranges   - Length B cell array of ranges or array of ranges.
% xcenters    - histogram bin centers
% 
% res      - Normalized count of ranges in bins. Array of size B x
%            length(xcenters)

if ~iscell(ranges)
    res = hist(ranges,xcenters);
else
    B = length(ranges);
    res = zeros(B,length(xcenters));
    for i = 1:B
        res(i,:) = hist(ranges{i},xcenters);
    end
end
sumRow = sum(res,2);
res = bsxfun(@rdivide,res,sumRow);
end