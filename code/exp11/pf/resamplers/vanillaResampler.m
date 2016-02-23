function particlesOut = vanillaResampler(particlesIn,weights)
    %VANILLARESAMPLER
    %
    % particlesOut = VANILLARESAMPLER(particlesIn,weights)
    %
    % particlesIn  - Struct array.
    % weights      - Vector.
    %
    % particlesOut - Struct array.
    
    P = length(particlesIn);
    particlesOut = particlesIn;
    
    % if low variance, don't resample
    
    % normalize weights
    weightSum = sum(weights);
    condn = weightSum > 0;
    assert(condn,'sum of weights is zero!');
    weights = weights/weightSum;
    
    ids = randsample(1:P,P,true,weights);
    particlesOut = particlesIn(ids);
end