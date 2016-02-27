function probArray = thrunProbArray(X,laser,params)
    %THRUNPROBARRAY
    %
    % probArray = THRUNPROBARRAY(X,laser,params)
    %
    % X         - [N,1]
    % laser     - laserClass 
    % params    - Length 3 vector, [sigma,lambda,alpha].
    %
    % probArray - [N,H]
        
    X = flipVecToColumn(X);
    N = length(X);
    sigma = params(1);
    lambda = params(2);
    alpha = params(3);
    
    % xc
    yValues = laser.readingsSet();
    yValues = flipVecToRow(yValues);
    yResn = yValues(2)-yValues(1);
    
    % snap X
    X(X < yValues(1)) = yValues(1);
    X(X > yValues(end)) = yValues(end);

    % the gaussian part
    x2 = yValues+yResn*0.5;
    x2 = repmat(x2,N,1);
    x2 = bsxfun(@minus,x2,X);
    x2 = bsxfun(@rdivide,x2,repmat(sigma,N,1));
    
    x1 = yValues-yResn*0.5;
    x1 = repmat(x1,N,1);
    x1 = bsxfun(@minus,x1,X);
    x1 = bsxfun(@rdivide,x1,repmat(sigma,N,1));
    
    probArrayGaussian = 0.5*(erf(x2./sqrt(2))-erf(x1./sqrt(2))); % [N,H]
    
    % the exp part
    x2 = yValues+yResn*0.5;
    x1 = yValues-yResn*0.5;
    % just probability in bins
    vec = expcdf(x2,1/lambda)-expcdf(x1,1/lambda);
    mat = repmat(vec,N,1);
    % different normalization factors
    normFactors = 1./(1-exp(-lambda.*X)); % [N,1]
    mat = bsxfun(@rdivide,mat,normFactors);
    % zero prob at ranges > nominal
    mask = repmat(yValues,N,1);
    mask = bsxfun(@le,yValues,X);
    probArrayExp = mat.*mask;
    
    % finally, sum
    probArray = alpha*probArrayGaussian+(1-alpha)*probArrayExp;
end