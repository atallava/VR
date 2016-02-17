function [desiredRadius,desiredSpeed] = computeControls(desiredPath,vehicleState,params)
    %COMPUTECONTROLS
    %
    % [desiredRadius,desiredSpeed] = COMPUTECONTROLS(desiredPathSegments,vehicleState,params)
    %
    % desiredPathSegments -
    % vehicleState        -
    % params              -
    %
    % desiredRadius       -
    % desiredSpeed        -
    
    pt = vehicleState(1:2);
    pt = flipVecToRow(pt);
    nSegments = size(desiredPath.pts,1)-1;
    
    % localize
    [closestPt,closestPtDist,closestSegmentId,lookaheadPt] = localizer(desiredPath.pts,pt,params.lookaheadDist);
    
    % too far from path
    if closestPtDist > params.maxDistanceThreshold
        fprintf('Distance to desired path exceeds %.2f, bailing.\n',params.maxDistanceThreshold);
        desiredSpeed = 0.0;
        desiredRadius = 1e6;
        return;
    end
    
    % sanity on proximity to current location if at last segment
    % progressForDone depends on resolution. not checking resolution here
    if closestSegmentId == nSegments && ...
            progressAlongSegment(desiredPath.pts(end-1:end,:),pt) >= params.progressForDone
        fprintf('Vehicle at last segment.\n');
        desiredSpeed = 0.0;
        desiredRadius = 1e6;
        return;
    end
    
    % vec1 is from vehicle to lookahead
    vec1 = lookaheadPt-pt;
    yaw = vehicleState(3);
    % vec2 is vec1 in vehicle frame
    vec2(1) = vec1(1)*cos(yaw)+vec1(2)*sin(yaw);
    vec2(2) = -vec1(1)*sin(yaw)+vec1(2)*cos(yaw);
    
    % sanity on x_la
    if vec2(1) == 0.0
        desiredRadius = 1e6;
    else
        desiredRadius = sum(vec2.^2)/(2*vec2(2));
    end
    desiredSpeed = desiredPath.speed(closestSegmentId);
end