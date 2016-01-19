function [regRisk,losses] = modelObj(lossFn,dataset,model,modelParams,lambda)
    %MODELOBJ Wrapper around modelRisk.
    %
    % regRisk = MODELOBJ(lossFn,dataset,model,modelParams)
    %
    % lossFn      -
    % dataset     -
    % model       -
    % modelParams - Vector or struct.
    % lambda      - Regularization constant. Default: 0.
    %
    % regRisk     - Regularized risk.
    % losses      - Losses over 
    
    model.updateModelParams(modelParams);
    nSamples = 3;
    riskSamples = zeros(1,nSamples);
    nElements = length(dataset);
    lossesSamples = zeros(nSamples,nElements);
    for i = 1:nSamples
        [riskSamples(i),lossesSamples(i,:)] = modelRisk(lossFn,dataset,model);
    end
    risk = mean(riskSamples);
    losses = mean(lossesSamples,1);
    
    if nargin < 5
        lambda = 0;
    end
    if isstruct(modelParams)
        modelParams = model.modelParamsStructToVec(modelParams);
    end
    regTerm = lambda*norm(modelParams);
    regRisk = risk+regTerm;
end