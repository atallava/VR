function h = histogramFromOrthogonalCosine(theta,xc)
    % theta is [N,J]
    % xc is [1,R]
    % h is [N,R]
    
    binWidth = xc(2)-xc(1);
    [N,J] = size(theta);
    if iscolumn(xc); xc = xc'; end
    X = repmat(xc,J,1);
    X = pi*bsxfun(@times,X,[0:(J-1)]');
    Y = sqrt(2)*cos(X);
    h = theta*Y;
    h = h*binWidth;
    colSum = sum(h,2);
    h = bsxfun(@rdivide,h,colSum);
end