function alpha = progressAlongSegment(segment,pt)
    % unit vector from segment start to segment end
    vec1 = [segment.endPt.x-segment.startPt.x ...
        segment.endPt.y-segment.startPt.y];
        
    % vector from segment start to pt
    vec2 = [pt.x-segment.startPt.x ...
        pt.y-segment.startPt.y];
    
    alpha = dot(vec1,vec2)/sum(vec1.^2);
end