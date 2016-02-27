function weights = getWeightsThrun(map,sensor,ranges,bearings,particles,params)
    %GETWEIGHTSTHRUN
    %
    % weights = GETWEIGHTSTHRUN(map,sensor,ranges,bearings,particles,params)
    %
    % map       - lineMap object.
    % sensor    - laserClass object.
    % ranges    - Vector.
    % bearings  - Vector.
    % particles - Struct array.
    % params    - [sigma,lambda,alpha]
    %
    % weights   -
    
    truncateLw = -7;
    
    % don't care about ranges which are null
    invalidIds = ranges == sensor.nullReading;
    ranges(invalidIds) = [];
    bearings(invalidIds) = [];

    P = length(particles);
    B = length(bearings);
   
    % snap ranges to max range
    ranges(ranges > sensor.maxRange) = sensor.maxRange;
    binIds = round(ranges./sensor.rangeRes)+1;
    binIds = flipVecToColumn(binIds);
    poses = [particles.pose];
    [rangesNominal,alphasNominal] = map.raycast(poses',5,bearings); % [nPoses,nBearings]
    % unroll nominal to get state
    % unrolled as [... pose_i,bearing_1 ... pose_i,bearing_B
    % pose_i+1,bearing_1 ...]
    rangesNominal = reshape(rangesNominal',numel(rangesNominal),1); 
    alphasNominal = reshape(alphasNominal',numel(alphasNominal),1);
    X = [rangesNominal alphasNominal];
    % get probability histograms
    h = thrunProbArray(rangesNominal,sensor,params);
        
    ids = sub2ind(size(h),[1:P*B]',repmat(binIds,P,1));
    probs = h(ids); % [P*B,1]
    % log weights
    lw = log(probs); % [P*B,1]
    % don't count evidence if rangesNominal is null
    lw(rangesNominal == sensor.nullReading) = 0;
    % truncate log weights
    lw(lw < truncateLw) = truncateLw;
    
    % mat sums relevant sections of lw
    mat = zeros(P,P*B); % [P,PB]
    % the row and column subscripts of non-zero elements in mat
    matRowSubs = repelem(1:P,B);
    matColSubs = 1:P*B;
    nonZeroIds = sub2ind(size(mat),matRowSubs,matColSubs);
    mat(nonZeroIds) = 1;
    
    % sum of log weights
    % sumLw(i) = sum(lw((i-1)*B+1:i*B))
    sumLw = mat*lw; % [P,1]
    
    % finally weights
    weights = exp(sumLw); % [P,1]
    
    condn = ~any(isnan(weights));
    assert(condn,'weights are nan!');
end