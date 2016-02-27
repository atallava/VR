function probs = thrunModelProb(X,Z,laser,params)
    % probability of observations given nominal range
    % X is [N,1]
    % Z is [N,1]
    % params is [sigma,lambda,alpha]
        
    N = length(X);
    probArray = thrunProbArray(X,laser,params); % [N,H]
    
    % snap readings
    Z(Z > laser.maxRange) = laser.maxRange;
    colSubs = round(Z./laser.rangeRes)+1;
    rowSubs = [1:N]';
    ids = sub2ind(size(probArray),rowSubs,colSubs);
    probs = probArray(ids);
end