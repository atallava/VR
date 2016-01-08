function obj = algoObjParamsVec(data,paramsVec)
    %ALGOOBJPARAMSVEC Wrapper over algoObj that takes parameters as vector.
    % Intended for use with fmincon.
    % obj = ALGOOBJPARAMSVEC(data,paramsVec)
    %
    % data      -
    % paramsVec - [1,2] array of [maxErr,epsScale].
    %
    % obj       -
    
    load('data/algo_param_eps_vector','eps0');
    params.maxErr = paramsVec(1);
    params.eps = paramsVec(2)*eps0;
    obj = algoObj(data,params);
end