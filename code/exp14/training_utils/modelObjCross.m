function risk = modelObjCross(lossFns,dataset,model,modelParams)
    %MODELOBJCROSS Wrapper around modelRiskCross.
    %
    % risk = MODELOBJCROSS(lossFns,dataset,model,modelParams)
    %
    % lossFns     - 
    % dataset     -
    % model       -
    % modelParams - Vector or struct.
    %
    % risk        -

    model.updateModelParams(modelParams);
    risk = modelRiskCross(lossFns,dataset,model);
end