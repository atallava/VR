function [res,xcenters] = ranges2Histogram(ranges)
deltaRange = 1e-3; % 1mm
maxRange = 4.5; 
nCenters = (maxRange/deltaRange)+1;
xcenters = linspace(0,maxRange,nCenters);
res = hist(ranges,xcenters);
end