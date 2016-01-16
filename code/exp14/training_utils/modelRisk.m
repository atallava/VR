function [risk,losses] = modelRisk(lossFn,dataset,model)
    %MODELRISK
    %
    % risk = MODELRISK(lossFn,dataset,model)
    %
    % lossFn  - Function handle.
    % dataset - Struct array with fields ('X','Y').
    % model   - Model class object.
    %
    % risk    - Scalar.
    % losses  - Vector of losses.

    debugFlag = false;
    if debugFlag
        fprintf('lossFn: %s.\n',func2str(lossFn));
        fprintf('nElements: %d.\n',length(dataset));
        fprintf('model class: %s.\n',class(model));
    end
    
    clockLocal = tic();
    nElements = length(dataset);
    losses = zeros(1,nElements);
    parfor i = 1:nElements
        X = dataset(i).X;
        Y = dataset(i).Y;
        losses(i) = lossFn(X,Y,model);
    end
    risk = mean(losses);
    tComp = toc(clockLocal);
    
    if debugFlag
        fprintf('modelRisk:Computation time: %.2f.\n',tComp);
    end
    if isnan(risk)
        error('modelRisk:invalidOutput','risk is nan');
    end
end