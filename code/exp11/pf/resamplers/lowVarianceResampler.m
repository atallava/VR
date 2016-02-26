function particlesOut = lowVarianceResampler(particlesIn,weights)
    %LOWVARIANCERESAMPLER
    %
    % particlesOut = LOWVARIANCERESAMPLER(particlesIn,weights)
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

    % cumulative weights
    cWeights = cumsum(weights);
    
    % the 'comb'
    toothSepn = 1/P;
    tooth0 = rand()*toothSepn;
    teeth = [0:(P-1)]*toothSepn+tooth0;
    
    cWeights = flipVecToRow(cWeights);
    cWeightsMat = repmat(cWeights,P,1);
    teeth = flipVecToColumn(teeth);
    teethMat = repmat(teeth,1,P);
    
    flag = cWeightsMat < teethMat;
    ids  = sum(flag,2)+1;
    ids(ids > P) = P;
    
    particlesOut = particlesIn(ids);
end