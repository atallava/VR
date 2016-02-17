function [minDist,closestPt,segmentId] = findClosestSegment(refPath,pt)
    % squared distances to all segments
    dist2 = dist2ToSegments(refPath.segments,pt);
    
    % pick minimum
    [minDist2,segmentId] = min(dist2);
    minDist = sqrt(minDist2);

    closestSegment = segments(segmentId);
    distAlongSegment = progressAlongSegment(closestSegment,pt);
    
    % calculate closest point on segment
    closestPt = zeros(1,2);
    th = atan2(closestSegment.endPt(2)-closestSegment.startPt(2),...
        closestSegment.endPt(1)-closestSegment.startPt(1));
    closestPt(1) = closestSegment.startPt(1)+distAlongSegment*cos(th);
    closestPt(2) = closestSegment.startPt(2)+distAlongSegment*sin(th);
end