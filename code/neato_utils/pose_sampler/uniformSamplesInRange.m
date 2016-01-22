function samples = uniformSamplesInRange(varLims,nSamples)
    %UNIFORMSAMPLESINRANGE
    %
    % samples = UNIFORMSAMPLESINRANGE(varLims,nSamples)
    %
    % varLims  - [2,nVars] array. [min1 min2 ...; max1 max2 ...].
    % nSamples - Scalar. Defaults to 1.
    %
    % samples  - [nSamples,nVars] array.
    
    if nargin < 2
        nSamples = 1;
    end
    
    condn = size(varLims,1) == 2;
    assert(condn,'uniformSampleInRange:invalidInput','ranges is [2,nVars]');
    
    nVars = size(varLims,2);
    varRanges = range(varLims,1); 
    samples = rand(nSamples,nVars);
    samples = bsxfun(@times,samples,varRanges);
    samples = bsxfun(@plus,samples,varLims(1,:));
end