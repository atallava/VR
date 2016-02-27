function nll = thrunModelNll(X,Z,laser,params)
    %THRUNMODELNLL
    %
    % nll = THRUNMODELNLL(X,Z,laser,params)
    %
    % X      - [N,1]
    % Z      - [N,1]
    % laser  - laserClass object.
    % params - [sigma,lambda,alpha]
    %
    % nll    - Scalar.
    
    probs = thrunModelProb(X,Z,laser,params);
    nll = -sum(log(probs));
end