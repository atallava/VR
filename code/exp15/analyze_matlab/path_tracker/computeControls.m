function [desiredSpeed,desiredRadius] = computeControls(desiredPath,vehicleState,params)
    pt = vehicleState(1:2);
    pt = flipVecToRow(pt);
    
    % get closest segment
    [minDist,closestPt,segmentId] = findClosestSegment(desiredPath,pt);
    
    % too far from path
    if minDist > params.maxMinDist
        fprintf('Distance to desired path exceeds %.2f, bailing.\n',params.maxMinDist);
        desiredSpeed = 0.0;
        desiredRadius = 1e6;
        return;
    end
    
    % sanity on proximity to current location if at last segment
    % progressForDone depends on resolution. not checking resolution here
    if segmentId == length(desiredPath.segments) && ...
            progressAlongSegment(desiredPath.segments(segmentId),pt) >= params.progressForDone
        fprintf('Vehicle at last segment.\n');
        desiredSpeed = 0.0;
        desiredRadius = 1e6;
        return;
    end
    
    % walk along segment for lookahead distance
    lookaheadPt = findLookaheadPt(desiredPath,segmentId,closestPt,params.lookaheadDist);
    % vec1 is from vehicle to lookahead 
    vec1 = lookaheadPt-pt;
    th = vehicleState(3);
    % vec2 is vec1 in vehicle frame
    vec2(1) = vec1(1)*cos(th)+vec1(2)*sin(th);
    vec2(2) = -vec1(1)*sin(th)+vec1(2)*cos(th);
    
    % sanity on x_la
    if vec2(1) == 0.0
        desiredRadius = 1e6;
    else
        desiredRadius = sum(vec2.^2)/(2*vec2(2));
    end
    desiredSpeed = desiredPath.segments(segmentId).speed;
end