function objInsts = calcObjInsts(dataFName,algoParams,addIn)
    %CALCOBJINSTS Just a wrapper around calcObjInst
    %
    % objInsts = CALCOBJINSTS(dataFName,algoParams)
    %
    % dataFName  -
    % algoParams -
    %
    % objInsts   -
    
    debugFlag = false;
    writeFlag = false;
    
    load(dataFName);
    nX = length(X);
    objInsts = zeros(1,nX);
    
    for i = 1:nX
       objInsts(i) = calcObjInst(X,Y,algoParams,addIn); 
    end
    
    if writeFlag
        % decide file name
        fname = '1';
        save(fname,'objInsts','algoParams');
    end
end