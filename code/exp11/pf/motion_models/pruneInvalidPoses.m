function particlesOut = pruneInvalidPoses(particlesIn,map,support,bBox)
    %PRUNEINVALIDPOSES
    %
    % particlesOut = PRUNEINVALIDPOSES(particlesIn,map,support,bBox)
    %
    % particlesIn  - Struct array with fields ('pose').
    % map          - lineMap object.
    % support      - Struct with fields ('xv','yv').
    % bBox         - Struct with fields ('xv','yv').
    %
    % particlesOut - Struct array with fields ('pose').

    % find particles at invalid poses
    P = length(particlesIn);
    flag = zeros(1,P);
    for i = 1:P
        pose = particlesIn(i).pose;
        tBBox = transformPolygon(pose,bBox);
        if isValidPose(map,support,tBBox)
            flag(i) = 1;
        end
    end
    flag = logical(flag);
    particlesOut = particlesIn;
    particlesOut(~flag) = [];
    if isempty(particlesOut)
        error('pruneInvalidPoses:noValidPoses','No valid poses among particles.');
    end
    
    % compensate by creating copies of valid particles
    dP = P-length(particlesOut);
    ids = randsample(1:length(particlesOut),dP,'true');
    particlesOut = [particlesOut particlesOut(ids)];
end