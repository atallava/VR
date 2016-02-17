function [closestPt,closestPtDist,segmentId] = findClosestSegment(pathPts,pt)
    nSegments = size(pathPts,1)-1;
    closestPts = zeros(nSegments,2);
    
    startPts = pathPts(1:end-1,:);
    endPts = pathPts(2:end,:);
    
    segmentVecs = endPts-startPts;
    colNorm2 = sum(segmentVecs.^2,2);
    ptVecs = repmat(pt,nSegments,1)-startPts;
    alphas = sum(segmentVecs.*ptVecs,2);
    alphas = bsxfun(@rdivide,alphas,colNorm2);
    
    % closest point is start
    flag1 = alphas < 0;
    closestPts(flag1,:) = startPts(flag1,:);
    
    % closest point is end
    flag2 = alphas > 1;
    closestPts(flag2,:) = endPts(flag2,:);
    
    % else, on segment
    flag3 = ~(flag1 | flag2);
    th = atan2(segmentVecs(:,2),segmentVecs(:,1));
    closestPts(flag3,:) = startPts(flag3,:)+bsxfun(@times,[cos(th(flag3)) sin(th(flag3))],th(flag3));
    
    % pick closest point
    closestPtDists = closestPts-repmat(pt,nSegments,1);
    closestPtDists = sqrt(sum(closestPtDists.^2,2));
    [closestPtDist,segmentId] = min(closestPtDists);
    closestPt = closestPts(segmentId,:);
end