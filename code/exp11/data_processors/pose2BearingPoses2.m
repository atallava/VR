function [X,bearingGroupsX,pIds] = pose2BearingPoses2(poses,bearingGroups)
%POSE2BEARINGPOSES Generate sensor bearing poses from robot pose.
% 
% [X,pIds] = POSE2BEARINGPOSES(poses,bearings)
% 
% poses    - Array of size dimPose x nPoses.
% bearingsGroups - Array of size [G,g]
% 
% X        - Array of size (nPoses*G) x dimPoses.
% pIds     - Vector of length (nPoses*G). Maps bearing group pose to
%            robot pose.

[G,g] = size(bearingGroups);
N = size(poses,2);
pIds = zeros(N*G,1);

for i = 1:N
    pose = poses(:,i)';
    mat = repmat(pose,G,1);
    mat(:,3) = mean(bearingGroups,2);
    X((i-1)*G+1:i*G,:) = mat;
    pIds((i-1)*G+1:i*G) = i;
end
bearingGroupsX = repmat(bearingGroups,G,1);
end

