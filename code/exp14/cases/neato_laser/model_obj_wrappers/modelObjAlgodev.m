function obj = modelObjAlgodev(modelParams,laserModel,algosVars)
    %MODELOBJALGODEV Wrapper around risk. For use in fmincon.
    %
    % obj = MODELOBJALGODEV(kernelParams,laserModel,algosVars)
    %
    % kernelParams -
    % laserModel   -
    % algosVars    -
    %
    % obj          -
    
    kernelParams = struct('h',modelParams);
    laserModel.updateKernelParams(kernelParams);
    obj = modelRiskAlgodev(laserModel,algosVars);
end