function obj = algoObjParamsVec(data,paramsVec)
    %ALGOOBJPARAMSVEC Wrapper over algoObj that takes parameters as vector.
    % Intended for use with fmincon.
    % obj = ALGOOBJPARAMSVEC(data,paramsVec)
    %
    % data      -
    % paramsVec - [1,2] array of [scale,pOcc].
    %
    % obj       -
    
    params.scale = paramsVec(1);
    params.pOcc = paramsVec(2);
    obj = algoObj(data,params);
end