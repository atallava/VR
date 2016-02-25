function [h,hCenters] = estimateHistogramFast(XTrain,ZTrain,X,laser,bwX,trainHistEst)
%ESTIMATEHISTOGRAM
%
% [h,hCenters] = ESTIMATEHISTOGRAM(XTrain,ZTrain,X,laser,bwX,bwZ)
%
% XTrain    - N x dimX array.
% ZTrain    - length N cell array.
% X         - Q x dimX array. Q is number of queries.
% laser     - laserClass object.
% bwX       - Bandwidth in x.
% bwZ       - Bandwidth in y.
%
% h         - Q x hCenters array of histogram values.
% hCenters  - Histogram centers.

nHCenters = round(laser.maxRange/laser.rangeRes)+1; % number of histogram centers
hCenters = linspace(0,laser.maxRange,nHCenters); % histogram centers
hBinW = hCenters(2)-hCenters(1); % histogram bin width
k = 1; % fine-graining factor
nICenters = nHCenters*k; % number of integration centers
iBinW = hBinW/k; % integration bin width
iCenters = [0:nICenters-1]*iBinW-iBinW; % integration centers

Q = size(X,1);
% estimate density values
p = dRegressWithHistEst(XTrain,ZTrain,X,bwX,trainHistEst);

% get histogram values
h = zeros(Q,nHCenters);
for i = 1:nHCenters
    h(:,i) = sum(p(:,k*(i-1)+1:k*i),2);
end
h = h*iBinW;
% normalize histograms
colSum = sum(h,2);
nonZero = (colSum ~= 0);
if ~any(nonZero)
    return;
else
    h(nonZero,:) = bsxfun(@rdivide,h(nonZero,:),colSum(nonZero));
end
end