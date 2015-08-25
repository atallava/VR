function [X,bearingsX,pIds] = pose2BearingFeatures(poses,bearings,map,sensor)
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
% bearingsX - Vector of length (nPoses*nBearings). Maps X to sensor
%             bearing.

if iscolumn(bearings) bearings = bearings'; end
nBearings = length(bearings);

pIds = [];
X = zeros(size(poses,2)*nBearings,2);
for i = 1:size(poses,2)
    pose = poses(:,i);
    [r,alpha] = map.getRAlpha(pose,sensor.maxRange,bearings);
    X((i-1)*nBearings+1:i*nBearings,:) = [r' alpha'];
    pIds = [pIds; i*ones(nBearings,1)];
end
if isrow(bearings)
    bearings = bearings';
end
bearingsX = repmat(bearings,size(poses,2),1);
end
