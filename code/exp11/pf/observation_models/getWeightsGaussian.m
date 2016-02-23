function weights = getWeightsGaussian(map,sensor,ranges,bearings,particles)
    %GETWEIGHTSGAUSSIAN
    %
    % weights = GETWEIGHTSGAUSSIAN(map,sensor,ranges,bearings,particles)
    %
    % map       - lineMap object.
    % sensor    - laserClass object.
    % ranges    - Vector.
    % bearings  - Vector. 
    % particles - Struct array.
    %
    % weights   - Vector.

    P = length(particles);
    B = length(bearings);
    sigma = 0.1;
    truncateLw = -10;
    
    poses = [particles.pose];
    [rangesNominal,~] = map.raycast(poses',sensor.maxRange,bearings);
    ranges = flipVecToRow(ranges);
    rangesMat = repmat(ranges,P,1);
    
    % filter out null readings
    mask = ~((rangesNominal == sensor.nullReading) | ...
        (rangesMat == sensor.nullReading));
    probMat = normpdf(rangesMat,rangesNominal,sigma);
    lwMat = log(probMat);
    lwMat(~mask) = 0;
    lwColSum = sum(lwMat,2);
    lwColSum(lwColSum < truncateLw) = truncateLw;
    weights = exp(lwColSum);
end