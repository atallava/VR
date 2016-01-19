function paramsStruct = algoParamsVecToStruct(paramsVec)
    %ALGOPARAMSVECTOSTRUCT
    %
    % paramsStruct = ALGOPARAMSVECTOSTRUCT(paramsVec)
    %
    % paramsVec    - [1,2] array.
    %
    % paramsStruct - Struct with fields ('maxErr','eps').
    
    paramsStruct.maxErr = paramsVec(1);
    load('data/algo_param_eps_vector','eps0');
    paramsStruct.eps = paramsVec(2)*eps0;
end