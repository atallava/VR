function [obj,objElements] = algoObjDataset(dataset,params)
    %ALGOOBJDATASET
    %
    % [obj,objElements] = ALGOOBJDATASET(dataset,params)
    %
    % dataset     - Struct array with fields ('X','Y').
    % params      - 
    %
    % obj         -
    % objElements -
    
    nElements = length(dataset);
    objElements = zeros(1,nElements);
    for i = 1:nElements
        X = dataset(i).X;
        Y = dataset(i).Y;
        objElements(i) = algoObj(X,Y,params);
    end
    obj = mean(objElements);
end