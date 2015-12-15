function [loss,algoParams] = calcLoss(realDataFName,simDataFName,addIn)
    %CALCLOSS
    %
    % [loss,algoParams] = CALCLOSS(realDataFName,simDataFName)
    %
    % realDataFName -
    % simDataFName  -
    %
    % loss          -
    % algoParams    -
    
    debugFlag = false;
    
    % load sample of algo parameters
    load('algo_params_samples');
    
    algoObjDiffs = zeros(1,nSamples);
    
    clockLocal = tic();
    % loop over samples
    for i = 1:nSamples
        algoParams = algoParamsSamples(i,:);
        % calculate algo instance objectives for real data
        algoObjInstsReal = calcObjInsts(realDataFName,algoParams,addIn);
        % calculate algo instance objectives for sim data
        algoObjInstsSim = calcObjInsts(simDataFName,algoParams,addIn);
        % calculate algo objective difference
        % CHECK: this might as well be norm of average
        vec = algoObjInstsReal-algoObjInstsSim;
        algoObjDiff = vec.^2/length(vec);
        algoObjDiffs(i) = algoObjDiff;
    end
    tComp = toc(clockLocal);
    if debugFlag
        fprintf('calcLoss:Computation time: %.2fs.\n',tComp);
    end
    
    % set loss to max algo objective difference
    [loss,id] = max(algoObjDiffs);
    algoParams = algoParamsSamples(id,:);
end