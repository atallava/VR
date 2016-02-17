function [closestPt,closestPtDist,closestSegmentId,lookaheadPt] = localizer(pathPts,pt,lookaheadDist)
    [closestPt,closestPtDist,closestSegmentId] = findClosestSegment(pathPts,pt);
    lookaheadPt = findLookaheadPt(pathPts,closestSegmentId,closestPt,lookaheadDist);
end
    