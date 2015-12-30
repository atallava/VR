function obj = algoObjParamsVec(data,paramsVec)
    %ALGOOBJPARAMSVEC Wrapper over algoObj that takes parameters as vector.
    % Intended for use with fmincon.
    % obj = ALGOOBJPARAMSVEC(data,paramsVec)
    %
    % data      -
    % paramsVec - [1,2] array of [nMin,errorThresh].
    %
    % obj       -
    
    params.nMin = paramsVec(1);
    params.errorThresh = paramsVec(2);
    obj = 1+algoObj(data,params);
end