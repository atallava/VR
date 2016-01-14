function loss = lossDes(X,Y,model,algoObj,algoParamsSamples)
    %LOSSDES
    %
    % loss = LOSSDES(X,Y,model,algoObj,algoParamsSamples)
    %
    % X                 -
    % Y                 -
    % model             -
    % algoObj           -
    % algoParamsSamples -
    %
    % loss              -
    
    debugFlag = false;
    
    clockLocal = tic();
    nSamples = length(algoParamsSamples);
    lossVec = zeros(1,nSamples);
    parfor i = 1:nSamples
        algoParams = algoParamsSamples(i);
        lossVec(i) = lossVer(X,Y,model,algoObj,algoParams);
    end
    loss = max(lossVec);
    tComp = toc(clockLocal);
    
    if debugFlag
        fprintf('lossDes:Computation time: %.2f.\n',tComp);
    end
    if isnan(loss)
        error('lossDes:invalidOutput','loss is nan');
    end
end