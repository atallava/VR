function risk = modelRiskCross(lossFns,dataset,model)
    %MODELRISKCROSS
    %
    % risk = MODELRISKCROSS(lossFns,dataset,model)
    %
    % lossFns - Cell array of function handles.
    % dataset - Struct array with fields ('X','Y').
    % model   - Model class object.
    %
    % risk    - Scalar.

    debugFlag = false;
    
    clockLocal = tic();
    nAlgos = length(lossFns);
    nElements = length(dataset);
    condn = nAlgos == nElements;
    assert(condn,'modelRiskCross:invalidInput',...
        'Number of loss functions must equal elements in dataset.');
    
    risk = 0;
    for i = 1:nElements
        lossFn = lossFns{i};
        X = dataset(i).X;
        Y = dataset(i).Y;
        risk = risk+lossFn(X,Y,model);
    end
    tComp = toc(clockLocal);
    
    if debugFlag
        fprintf('modelRiskCross:Computation time: %.2f.\n',tComp);
    end
    if isnan(risk)
        error('modelRiskCross:invalidOutput','risk is nan');
    end
end