function theta = estimateOrthogonalCosine(Z,J)
    % Z is a cell of length N. 
    % theta is [N,J]
    if ~iscell(Z)
        Z = {Z};
    end
    fundamentalPeriod = pi;
    N = length(Z);
    for i = 1:N
        z = Z{i};
        if isrow(z); z = z'; end
        x = fundamentalPeriod*repmat(z,1,J);
        x = bsxfun(@times,x,0:(J-1)); % [M,J] arguments for cosine
        y = sqrt(2)*cos(x); % function evaluations at data points
        theta(i,:) = mean(y,1); 
    end
    
end