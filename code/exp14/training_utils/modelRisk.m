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

    debugFlag = true;
    if debugFlag
        fprintf('lossFn: %s.\n',func2str(lossFn));
        fprintf('nElements: %d.\n',length(dataset));
        fprintf('model class: %s.\n',class(model));
    end
    
    clockLocal = tic();
    nElements = length(dataset);
    risk = 0;
    for i = 1:nElements
        X = dataset(i).X;
        Y = dataset(i).Y;
        risk = risk+lossFn(X,Y,model);
    end
    tComp = toc(clockLocal);
    
    if debugFlag
        fprintf('modelRisk:Computation time: %.2f.\n',tComp);
    end
    if isnan(risk)
        error('modelRisk:invalidOutput','risk is nan');
    end
end