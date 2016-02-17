function pathSegments = pathToSegments(desiredPath,params)
    % desiredPath is a struct array with fields ('x','y','speed','yawRate')
    % pathSegments is a struct array with fields
    % ('startPt','endPt','speed')
    
    nPts = length(desiredPath);
    nSegments = nPts-1;
    for i = 1:nSegments
        clear segment;
        startPt.x = desiredPath(i).x;
        startPt.y = desiredPath(i).y;
        endPt.x = desiredPath(i+1).x;
        endPt.y = desiredPath(i+1).y;
        segmentLength = norm([startPt.x startPt.y]-[endPt.x endPt.y]);
        
        if (segmentLength < params.smallestSegmentLength) || ...
                (segmentLength > params.largestSegmentLength)
            error('Segment length %2f is not in range %2f to %2f.\n',...
                segmentLength,params.smallestSegmentLength,params.largestSegmentLength);
        end
        pathSegments(i).startPt = startPt;
        pathSegments(i).endPt = endPt;
        pathSegments(i).speed = desiredPath(i).speed;
    end
end