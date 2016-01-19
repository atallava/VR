function paramsVec = algoParamsStructToVec(paramsStruct)
    %ALGOPARAMSSTRUCTTOVEC
    %
    % paramsVec = ALGOPARAMSSTRUCTTOVEC(paramsStruct)
    %
    % paramsStruct - Struct with fields ('maxErr','eps').
    %
    % paramsVec    - [1,2] array.
    
    paramsVec = zeros(1,2);
    paramsVec(1) = paramsStruct.maxErr;
    load('data/algo_param_eps_vector','eps0');
    paramsVec(2) = paramsStruct.eps(1)/eps0(1);
end