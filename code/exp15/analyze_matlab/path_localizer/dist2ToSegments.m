function dist2 = dist2ToSegments(segments,pt)
    % as needed by myDist
    pt = [pt.x pt.y];
    nSegments = length(segments);
    
    startPts = zeros(nSegments,2);
    endPts = zeros(nSegments,2);
    tmp = [segments.startPt];
    startPts(:,1) = [tmp.x];
    startPts(:,2) = [tmp.y];
    tmp = [segments.endPt];
    endPts(:,1) = [tmp.x];
    endPts(:,2) = [tmp.y];
    
    segmentVectors = endPts-startPts;
    colNorms = sqrt(sum(segmentVectors.^2,2));
    segmentVectors = bsxfun(@rdivide,segmentVectors,colNorms);
    ptVectors = repmat(pt,nSegments,1)-startPts;
    dist2 = ptVectors(:,1).*segmentVectors(:,2)-ptVectors(:,2).*segmentVectors(:,1);
    dist2 = dist2.^2;
    
%     dist2 = zeros(1,nSegments);
%     pt = pt';
%     for i = 1:nSegments
%         startPt = [segments(i).startPt.x; segments(i).startPt.y];
%         endPt = [segments(i).endPt.x; segments(i).endPt.y];
%         dist2(i) = myDist(pt,startPt,endPt);
%     end
end