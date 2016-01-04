function poses = uniformSamplesOnSupport(map,support,bBox,nPoses)
%UNIFORMSAMPLESONSUPPORT 
% 
% poses = UNIFORMSAMPLESONSUPPORT(map,support,bBox,nPoses)
% 
% map     - lineMap object.
% support - Struct with fields ('xv','yv'), or [n,2] array.
% bBox    - Struct with fields ('xv','yv'), or [n,2] array.
% nPoses  - 
% 
% poses   - [nPoses,3] array.

% Uses a uniform distribution on support.
% bBox is a bounding box.

if ~isstruct(support)
    support = struct('xv',support(:,1),'yv',support(:,2));
end
if ~isstruct(bBox)
    bBox = struct('xv',bBox(:,1),'yv',bBox(:,2));
end

poses = zeros(nPoses,3);
count = 1;
xMax = max(support.xv);
xMin = min(support.xv);
yMax = max(support.yv);
yMin = min(support.yv);
while true
    x = rand()*(xMax-xMin)+xMin;
    y = rand()*(yMax-yMin)+yMin;
    theta = rand()*2*pi;
    pose = [x y theta];
    tBBox = transformPolygon(pose,bBox);
    if isValidPose(map,support,tBBox)
        poses(count,:) = pose;
        count = count+1;
    end
    if count > nPoses;
        break;
    end
end

end

