function particlesOut = pruneInvalidPoses(particlesIn,map,support,bBox)

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
        error('correctInvalidPoses:noValidPoses','No valid poses among particles.');
    end
    
    % compensate
    dP = P-length(particlesOut);
    ids = randsample(1:length(particlesOut),dP);
    particlesOut = [particlesOut particlesOut(ids)];
end