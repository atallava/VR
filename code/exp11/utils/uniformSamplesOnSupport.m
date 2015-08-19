function poses = uniformSamplesOnSupport(support,map,bBox,nPoses)
% Uses a uniform distribution on support.
% bBox is a bounding box.

poses = zeros(3,nPoses);
count = 1;
xMax = max(support.xv);
xMin = min(support.xv);
yMax = max(support.yv);
yMin = min(support.yv);
while true
    x = rand()*(xMax-xMin)+xMin;
    y = rand()*(yMax-yMin)+yMin;
    theta = rand()*2*pi;
    pose = [x; y; theta];
    tBBox = transformPolygon(pose,bBox);
    in = inpolygon(support.xv,support.yv,tBBox.xv,tBBox.yv);
    outsidePoly = isempty(in);
    if outsidePoly
        continue;
    end
    collisionFree = true;
    for object = map.objects
        [xi,yi] = polyxpoly(support.xv,support.yv,tBBox.xv,tBBox.yv);
        collisionFree = isempty(xi);
        if ~collisionFree 
            break;
        end
    end
    if ~collisionFree
        continue;
    end
    poses(:,count) = pose;
    count = count+1;
    if count > nPoses;
        break;
    end
end

end

