function [hCell,hCenters1,hCenters2] = estimateHistogram2(XTrain,ZTrain,X,laser,bwX,bwZ)
%ESTIMATEHISTOGRAM2 2D version of estimateHistogram
%
% [h,hCenters] = ESTIMATEHISTOGRAM(XTrain,ZTrain,X,laser,bwX,bwZ)
%
% XTrain    - N x dimX array.
% ZTrain    - length N cell array. ZTrain{i} is [2,M].
% X         - Q x dimX array. Q is number of queries.
% laser     - laserClass object.
% bwX       - Bandwidth in x.
% bwZ       - Bandwidth in y.
%
% hCell        - cell array of size [1,Q]. hCell{1} is a histogram matrix
% hCenters  - Histogram centers.

nHCenters1 = round(laser.maxRange/laser.rangeRes)+1; % number of histogram centers
hCenters1 = linspace(0,laser.maxRange,nHCenters1); % histogram centers in dim1 
hCenters2 = hCenters1; % in dim2, same.
hBinW = hCenters1(2)-hCenters1(1); % histogram bin width
k = 1; % fine-graining factor
nICenters1 = nHCenters1*k; % number of integration centers
iBinW = hBinW/k; % integration bin width
iCenters1 = [0:nICenters1-1]*iBinW-iBinW; % integration centers in dim1
iCenters2 = iCenters1; % in dim2, same.

% list of hCenters
[vec1,vec2] = meshgrid(hCenters1,hCenters2);
% strange because vec2 goes before vec1. but this is because want the first
% coordinate to flip faster than second, which helps in creating masks.
hCentersList = [vec2(:)'; vec1(:)']; % reshape to recover meshgrid
nHCentersList = size(hCentersList,2);

% list of iCenters
[vec1,vec2] = meshgrid(iCenters1,iCenters2);
iCentersList = [vec2(:)'; vec1(:)']; % reshape to recover meshgrid
nICentersList = size(iCentersList,2);

% mask linking hCentersList to iCentersList
% cell because array cannot fit in memory.
% h2IMask = cell(1,nHCentersList);
% for j = 1:nHCentersList
%     [hSub1,hSub2] = ind2sub([nHCenters1,nHCenters1],j);
% 	vec1 = (k*(hSub1-1)+1):k*hSub1;
% 	vec2 = (k*(hSub2-1)+1):k*hSub2;
% 	[iSub1,iSub2] = meshgrid(vec1,vec2);
% 	iSub1 = iSub1(:); iSub2 = iSub2(:);
% 	iIds = sub2ind([nICenters1,nICenters1],iSub1,iSub2);
%     mask = zeros(1,nICentersList); 
%     mask(iIds) = 1;
%     h2IMask{j} = mask;
% end
% h2IMask = logical(h2IMask);

Q = size(X,1);
% estimate density values at iCentersList
p = dRegress2(XTrain,ZTrain,iCentersList,X,bwX,bwZ); % p is [Q,nICentersList]
p = p*(hBinW*2);

% % sum to get histogram values at hCentersList
% h = zeros(Q,nHCentersList);
% for i = 1:nHCentersList
% 	mask = logical(h2IMask(i,:));
% 	h(:,i) = sum(p(:,mask),2);
% end
% h = h*(iBinW^2); % multiply by differential area

% convert to cell array
hCell = cell(1,Q);
for i = 1:Q
	hCell{i} = reshape(h(i,:),[nHCenter1,nHCenters2]);
end
end