function [res,xcenters] = ranges2Histogram(ranges,laser)
% laser is a laserClass object
nCenters = (laser.maxRange/laser.rangeRes)+1;
xcenters = linspace(0,laser.maxRange,nCenters);
res = hist(ranges,xcenters);
end