function risk = modelRisk(lossFn,dataset,model)
    %MODELRISK
    %
    % risk = MODELRISK(lossFn,dataset,model)
    %
    % lossFn  - Function handle.
    % dataset - Struct array with fields ('X','Y').
    % model   - Model class object.
    %
    % risk    - Scalar.

    debugFlag = false;
    
    nElements = length(dataset);
    risk = 0;
    for i = 1:nElements
        X = dataset.X(i);
        Y = dataset.Y(i);
        risk = risk+lossFn(X,Y,model);
    end
    tComp = toc(clockLocal);
    
    if debugFlag
        fprintf('modelRisk:Computation time: %.2f.\n',tComp);
    end
end