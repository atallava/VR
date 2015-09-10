function weights = getWeightsGaussian(map,sensor,ranges,bearings,particles)
    
    P = length(particles);
    B = length(bearings);
    weights = zeros(1,P);
    sigma = 0.1;
    truncateLw = -8;
    
    for i = 1:P
        pose = particles(i).pose;
        [rangesNominal,~] = map.raycast(pose,sensor.maxRange,bearings);
        validIds = ~(rangesNominal == sensor.nullReading);
        lw = log(normpdf(ranges(validIds),rangesNominal(validIds),sigma));
        lw(lw < truncateLw) = truncateLw;
        weights(i) = exp(sum(lw));
    end    
end