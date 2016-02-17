function lookaheadPt = findLookaheadPt(pathPts,segmentId,closestPt,lookaheadDist)
    nSegments = size(pathPts,1)-1;
    segmentEndPt = pathPts(segmentId+1,:);
    remDistOnSegment = norm(segmentEndPt-closestPt);
       
    if remDistOnSegment > lookaheadDist
        % lookahead is on closest segment
        vec = pathPts(segmentId+1,:)-pathPts(segmentId,:);
        th = atan2(vec(2),vec(1));
        lookaheadPt = closestPt+lookaheadDist.*[cos(th) sin(th)];
        return;
    else
        % need to slide on to next segment
        if segmentId == nSegments
            lookaheadPt = pathPts(segmentId+1,:);
            return;
        end
        remLookaheadDist = lookaheadDist-remDistOnSegment;
        vec = pathPts(segmentId+2,:)-pathPts(segmentId+1,:);
        th = atan2(vec(2),vec(1));
        lookaheadPt = pathPts(segmentId+1,:)+lookaheadDist.*[cos(th) sin(th)];
    end
end