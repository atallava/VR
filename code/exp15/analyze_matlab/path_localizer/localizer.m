function [closestPt,closestPtDist,closestSegmentId,lookaheadPt] = localizer(segments,pt,lookaheadDist)
    [closestPt,closestPtDist,closestSegmentId] = findClosestSegment(segments,pt);
    lookaheadPt = findLookaheadPt(segments,closestSegmentId,closestPt,lookaheadDist);
end
    