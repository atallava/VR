function dist2 = dist2ToSegments(segments,pt)
    % as needed by myDist
    pt = flipVecToColumn(pt);
    nSegments = length(segments);
    dist2 = zeros(1,nSegments);
    for i = 1:nSegments
        segmentStartPt = segments(i).startPt;
        segmentStartPt = flipVecToColumn(segmentStartPt);
        segmentEndPt = segments(i).endPt;
        segmentEndPt = flipVecToColumn(segmentEndPt);
        dist2(i) = myDist(pt,segmentStartPt,segmentEndPt);
    end
end