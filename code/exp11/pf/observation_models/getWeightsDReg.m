function weights = getWeightsDReg(map,sensor,ranges,bearings,particles,predictor)
    % predictor = @(X) estimateHistogram(XTrain,ZTrain,X,sensor,bwX,bwZ);
    
    P = length(particles);
    B = length(bearings);
    weights = zeros(1,P);
    
    X = zeros(P,2);
    binIds = round(ranges./sensor.resolution)+1;
    for i = 1:P
        pose = particles(i).pose;
        [X(i,1),X(i,2)] = map.raycast(pose,sensor.maxRange,bearings);
    end
    [h,~] = predictor(X);
    for i = 1:P
        lw = log(h(i,binIds));
        weights(i) = exp(sum(lw));
    end
    
end