function [res,xc1,xc2] = rangePairs2Histogram(rangePairs,laser)
%RANGEPAIRS2HISTOGRAM 
% 
% [res,xc1,xc2] = RANGEPAIRS2HISTOGRAM(rangePairs,laser)
% 
% rangePairs - If cell, rangePairs{i} is size [M,2]. Else rangePairs is
%              size [M,2].
% laser      - laserClass instance.
% 
% res        - If cell, res{i} is size [nXc1,nXc2]. Else res is that size.
% xc1        - Length nXc1. Histogram centers in dim1.
% xc2        - Length nXc2. Histogram centers in dim2.

nHCenters1 = round(laser.maxRange/laser.rangeRes)+1; % number of histogram centers
xc1 = linspace(0,laser.maxRange,nHCenters1); % histogram centers in dim1 
xc2 =  xc1; % in dim2, same.

if ~iscell(rangePairs)
    res = hist3(rangePairs,{xc1 xc2});
    res = res/sum(res(:));
else
    res = cell(size(rangePairs));
    for i = 1:length(rangePairs)
       [res{i},~,~] = rangePairs2Histogram(rangePairs{i},laser);
    end
end
end