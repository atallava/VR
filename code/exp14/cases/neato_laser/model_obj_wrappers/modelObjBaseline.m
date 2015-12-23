function obj = modelObjBaseline(modelParams,laserModel,algosVars)
    %MODELOBJBASELINE Wrapper around risk. For use in fmincon.
    %
    % obj = MODELOBJBASELINE(kernelParams,laserModel,algosVars)
    %
    % kernelParams -
    % laserModel   -
    % algosVars    -
    %
    % obj          -
    
    kernelParams = struct('h',modelParams);
    laserModel.updateKernelParams(kernelParams);
    obj = modelRiskBaseline(laserModel,algosVars);
end