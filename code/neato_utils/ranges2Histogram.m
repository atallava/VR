function [res,xcenters] = ranges2Histogram(ranges,laser)
%RANGES2HISTOGRAM 
% 
% [res,xcenters] = RANGES2HISTOGRAM(ranges,laser)
% 
% ranges   - Length B cell array of ranges or array of ranges.
% laser    - laserClass object.
% 
% res      - Normalized count of ranges in bins. Array of size B x
%            length(xcenters)
% xcenters - Bin centers.

nCenters = (laser.maxRange/laser.rangeRes)+1;
xcenters = linspace(0,laser.maxRange,nCenters);

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