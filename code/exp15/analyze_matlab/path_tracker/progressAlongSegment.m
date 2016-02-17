function progressDist = progressAlongSegment(segment,pt)
    % unit vector from segment start to segment end
    vec1 = segment.endPt-segment.startPt;
    vec1 = vec1/norm(vec1);
    
    % vector from segment start to pt
    vec2 = pt-segment.startPt;
    
    progressDist = dot(vec1,vec2);
end