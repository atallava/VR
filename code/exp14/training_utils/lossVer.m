function loss = lossVer(X,Y,model,algoObj,algoParams)
    %LOSSVER
    %
    % loss = LOSSVER(X,Y,model,algoObj,algoParams)
    %
    % X          -
    % Y          -
    % model      -
    % algoObj    -
    % algoParams -
    %
    % loss       -
    
    debugFlag = false;
    
    clockLocal = toc();
    objReal = algoObj(X,Y,algoParams);
    YSim = model.predict(X);
    objSim = algoObj(X,YSim,algoParams);
    loss = (objReal-objSim)^2;
    tComp = toc(clockLocal);
    
    if debugFlag
        fprintf('lossVer:Computation time: %.2f.\n',tComp);
    end
end