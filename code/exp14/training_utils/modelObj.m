function risk = modelObj(lossFn,dataset,model,modelParams)
    %MODELOBJ Wrapper around modelRisk.
    %
    % risk = MODELOBJ(lossFn,dataset,model,modelParams)
    %
    % lossFn      -
    % dataset     -
    % model       -
    % modelParams - Vector or struct.
    %
    % risk        -

    model.updateModelParams(modelParams);
    risk = modelRisk(lossFn,dataset,model);
end