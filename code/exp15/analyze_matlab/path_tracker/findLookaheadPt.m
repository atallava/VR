function lookaheadPt = findLookaheadPt(segments,segmentId,closestPt,lookaheadDist)
    closestSegment = segments(segmentId);
    remDistOnSegment = norm([closestSegment.endPt.x-closestPt.x closestSegment.endPt.y-closestPt.y]);
   
    if remDistOnSegment <= lookaheadDist
        % lookahead is on closest segment
        th = atan2(closestSegment.endPt.y-closestSegment.startPt.y,...
            closestSegment.endPt.x-closestSegment.startPt.x);
        lookaheadPt.x = closestPt.x+lookaheadDist*cos(th);
        lookaheadPt.y = closestPt.y+lookaheadDist*sin(th);
        return;
    else
        % need to slide on to next segment
        if segmentId == length(segments)
            lookaheadPt = closestSegment.endPt;
            return;
        end
        nextSegment = segments(segmentId+1);
        remLookaheadDist = lookaheadDist-remDistOnSegment;
        th = atan2(nextSegment.endPt.y-nextSegment.startPt.y,...
            nextSegment.endPt.x-nextSegment.startPt.x);
        lookaheadPt.x = nextSegment.startPt.x+remLookaheadDist*cos(th);
        lookaheadPt.y = nextSegment.startPt.y+remLookaheadDist*sin(th);
    end
end