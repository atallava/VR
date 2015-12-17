function objInst = calcObjInst(X,Y,algoParams,addIn)
    %CALCOBJINST
    %
    % objInst = CALCOBJINST(X,Y,algoParams)
    %
    % X          -
    % Y          -
    % algoParams -
    %
    % objInst    -
    
    % algo specific 
    targetLength = 0.61;
    load(addIn{1}); % that is the path to target_lines_by_conf
    nMin = algoParams(1);
    errorThresh = algoParams(2);
    lineCandAlgo = @(x1,x2,x3,x4) lineCand(x1,x2,x3,x4,nMin,errorThresh);
    scans = Y;
    
    [nDetected,nCorrect,nTargets] = getPR(scans,targetLength,targetLinesByConf,lineCandAlgo);
    p = sum(nCorrect)/sum(nDetected);
    r = sum(nCorrect)/sum(nTargets);
    objInst = 2*p*r/(p+r);
end