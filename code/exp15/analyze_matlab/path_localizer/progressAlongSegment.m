function alpha = progressAlongSegment(segmentPts,pt)
    % unit vector from segment start to segment end
    vec1 = segmentPts(end,:)-segmentPts(1,:);
            
    % vector from segment start to pt
    vec2 = pt-segmentPts(1,:);
    
    alpha = dot(vec1,vec2)/sum(vec1.^2);
end