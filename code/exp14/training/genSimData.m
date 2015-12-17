function simData = genSimData(simModel,realData)
    %GENSIMDATA Wrapper around model prediction.
    %
    % GENSIMDATA(simModel,realDataFName,simDataFName)
    %
    % simModel      - 
    % realDataFName - Needed for state.
    % simDataFName  - Output file.
    
    debugFlag = false;
    
    simData = realData;
    clockLocal = tic();
    simData.Y = simModel.predict(simData.X);
    tComp = toc(clockLocal);
    if debugFlag
        fprintf('genSimData:Computation took %.2fs.',tComp);
    end
end