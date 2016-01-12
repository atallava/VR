function res = isVec(data)
    %ISVEC Vector is row or column data.
    %
    % res = ISVEC(data)
    %
    % data -
    %
    % res  - Logical.
    
    res = false;
    if isrow(data) || iscolumn(data)
        res = true;
    end
end