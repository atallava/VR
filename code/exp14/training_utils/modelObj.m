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
    nSamples = 3;
    for i = 1:nSamples
        [riskSamples(i),lossesSamples(i,:)] = modelRisk(lossFn,dataset,model);
    end
    risk = mean(riskSamples);
    losses = mean(lossesSamples,1);
end