function [desiredRadius,desiredSpeed] = computeControls(desiredPathSegments,vehicleState,params)
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
    
    pt.x = vehicleState.x;
    pt.y = vehicleState.y;
    
    % localize
    [closestPt,closestPtDist,closestSegmentId,lookaheadPt] = localizer(desiredPathSegments,pt,params.lookaheadDist);
    
    % too far from path
    if closestPtDist > params.maxDistanceThreshold
        fprintf('Distance to desired path exceeds %.2f, bailing.\n',params.maxDistanceThreshold);
        desiredSpeed = 0.0;
        desiredRadius = 1e6;
        return;
    end
    
    % sanity on proximity to current location if at last segment
    % progressForDone depends on resolution. not checking resolution here
    if closestSegmentId == length(desiredPathSegments) && ...
            progressAlongSegment(desiredPathSegments(end),pt) >= params.progressForDone
        fprintf('Vehicle at last segment.\n');
        desiredSpeed = 0.0;
        desiredRadius = 1e6;
        return;
    end
    
    % vec1 is from vehicle to lookahead 
    vec1 = [lookaheadPt.x-pt.x lookaheadPt.y-pt.y];
    yaw = vehicleState.yaw;
    % vec2 is vec1 in vehicle frame
    vec2(1) = vec1(1)*cos(yaw)+vec1(2)*sin(yaw);
    vec2(2) = -vec1(1)*sin(yaw)+vec1(2)*cos(yaw);
    
    % sanity on x_la
    if vec2(1) == 0.0
        desiredRadius = 1e6;
    else
        desiredRadius = sum(vec2.^2)/(2*vec2(2));
    end
    desiredSpeed = desiredPathSegments(closestSegmentId).speed;
end