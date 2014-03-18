function rAlphaArray = poses2RangeAlpha(envLineMap,poses,bearings)
%poses2RangeAlpha: get range and angle of information for poses
% envLineMap is a lineMap object
% poses is number of poses x 3
% bearings are in degrees
% rAlphaArray is number of poses x 2 x number of bearings

maxRange = 4;
rAlphaArray = zeros(size(poses,1),2,length(bearings));

for i = 1:size(poses,1)
    [r,alpha] = envLineMap.raycast(poses(i,:),maxRange,bearings);
    rAlphaArray(i,1,:) = r;
    rAlphaArray(i,2,:) = alpha;
end

end

