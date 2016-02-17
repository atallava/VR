function lookaheadPt = findLookaheadPt(pathPts,segmentId,closestPt,lookaheadDist)
    % closest point + remaining in segment
    pts = [closestPt; pathPts(segmentId+1:end,:)];
    
    % distances between points
    dists = diff(pts,1,1);
    dists = sqrt(sum(dists.^2,2));
    
    % cumulative distances
    csDists = cumsum(dists);
    
    % id in points which will serve as start
    flag = csDists < lookaheadDist;
    startId = sum(flag)+1;
    if startId == size(pts,1)
        % lookahead distance greater than all points
        lookaheadPt = pts(end,:);
    else
        vec = pts(startId+1,:)-pts(startId,:);
        th = atan2(vec(2),vec(1));
        if startId == 1
            distToGo = lookaheadDist;
        else
            distToGo = lookaheadDist-csDists(startId-1);
        end
        lookaheadPt = pts(startId,:)+distToGo.*[cos(th) sin(th)];
    end
end
