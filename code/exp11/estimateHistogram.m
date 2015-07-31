function [h,hCenters] = estimateHistogram(XTrain,ZTrain,X,laser,bwX,bwZ)
%ESTIMATEHISTOGRAM
%
% [h,hCenters] = ESTIMATEHISTOGRAM(XTrain,ZTrain,X,laser,bwX,bwZ)
%
% XTrain    - N x 1 array.
% ZTrain    - length N cell array.
% X         - S x 1 array.
% laser     - laserClass object.
% bwX       - Bandwidth.
% bwZ       - Bandwidth.
%
% h         - S x hCenters array of histogram values.
% hCenters  - Histogram centers.

nHCenters = (laser.maxRange/laser.rangeRes)+1; % number of histogram centers
hCenters = linspace(0,laser.maxRange,nHCenters); % histogram centers
hBinW = hCenters(2)-hCenters(1); % histogram bin width
k = 2; % fine-graining factor
nICenters = nHCenters*k; % number of integration centers
iBinW = hBinW/k; % integration bin width
iCenters = [0:nICenters-1]*iBinW-hBinW; % integration centers

S = size(X,1);
% estimate density values
p = dRegress(XTrain,ZTrain,iCenters,X,bwX,bwZ);
% get histogram values
h = zeros(S,nHCenters);
for i = 1:nHCenters
    h(:,i) = sum(p(:,k*(i-1)+1:k*i),2);
end
h = h*iBinW;
end
