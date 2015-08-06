function [X,pIds] = pose2BearingFeatures(poses,bearings,map,maxRange)
%POSE2BEARINGFEATURES Generate sensor bearing poses from robot poses and
% map.
% 
% [X,pIds] = POSE2BEARINGFEATURES(poses,bearings,map,maxRange)
% 
% poses    - Array of size dimPoses x nPoses.
% bearings - Vector of readings of bearings.
% map      - lineMap object.
% maxRange - Scalar. Defaults to 5m.
% 
% X        - Array of size (nPoses*nBearings) x dimFeatures.
% pIds     - Vector of length (nPoses*nBearings). Maps bearing pose to
%            robot pose.

if nargin < 4
    maxRange = 5;
end

if iscolumn(bearings) bearings = bearings'; end
nBearings = length(bearings);

pIds = [];
X = zeros(size(poses,2)*nBearings,2);
for i = 1:size(poses,2)
    pose = poses(:,i);
    [r,alpha] = map.getRAlpha(pose,maxRange,bearings);
    X((i-1)*nBearings+1:i*nBearings,:) = [r' alpha'];
    pIds = [pIds; i*ones(nBearings,1)];
end

end
