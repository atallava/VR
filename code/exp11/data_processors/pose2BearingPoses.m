function [X,bearingsX,pIds] = pose2BearingPoses(poses,bearings)
%POSE2BEARINGPOSES Generate sensor bearing poses from robot pose.
% 
% [X,pIds] = POSE2BEARINGPOSES(poses,bearings)
% 
% poses    - Array of size dimPoses x nPoses.
% bearings - Vector of readings of bearings.
% 
% X        - Array of size (nPoses*nBearings) x dimPoses.
% pIds     - Vector of length (nPoses*nBearings). Maps bearing pose to
%            robot pose.


if nargin < 2
    bearings = deg2rad(0:359);
end

if isrow(bearings) bearings = bearings'; end
nBearings = length(bearings);

pIds = [];
X = zeros(size(poses,2)*nBearings,size(poses,1));
for i = 1:size(poses,2)
    pose = poses(:,i)';
    mat = repmat(pose,nBearings,1);
    mat(:,3) = mod(mat(:,3)+bearings,2*pi);
    X((i-1)*nBearings+1:i*nBearings,:) = mat;
    pIds = [pIds; i*ones(nBearings,1)];
end
bearingsX = repmat(bearings,size(poses,2),1);
end

