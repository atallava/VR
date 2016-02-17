function lookaheadPt = findLookaheadPt(desiredPath,segmentId,closestPt,lookaheadDist)
    lookaheadPt = zeros(1,2);
    segments = desiredPath.segments;
    closestSegment = segments(segmentId);
    remDistOnSegment = norm(closestSegment.endPt-closestPt);
   
    if remDistOnSegment <= lookaheadDist
        % lookahead is on closest segment
    
        th = atan2(closestSegment.endPt(2)-closestSegment.startPt(2),...
            closestSegment.endPt(1)-closestSegment.startPt(1));
        lookaheadPt(1) = closestPt(1)+lookaheadDist*cos(th);
        lookaheadPt(2) = closestPt(2)+lookaheadDist*sin(th);
        return;
    else
        % need to slide on to next segment
        if segmentId == length(segments)
            lookaheadPt = closestSegment.endPt;
            return;
        end
        nextSegment = segments(segmentId+1);
        remLookaheadDist = lookaheadDist-remDistOnSegment;
        th = atan2(nextSegment.endPt(2)-nextSegment.startPt(2),...
            nextSegment.endPt(1)-nextSegment.startPt(1));
        lookaheadPt(1) = nextSegment.startPt(1)+remLookaheadDist*cos(th);
        lookaheadPt(2) = nextSegment.startPt(2)+remLookaheadDist*sin(th);
    end
end