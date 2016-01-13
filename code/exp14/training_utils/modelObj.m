function [risk,losses] = modelObj(lossFn,dataset,model,modelParams)
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
    % losses      - 

    model.updateModelParams(modelParams);
    [risk,losses] = modelRisk(lossFn,dataset,model);
end