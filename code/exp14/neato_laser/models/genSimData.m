function genSimData(simModel,realDataFName,simDataFName)
    %GENSIMDATA Generate simulated data.
    %
    % GENSIMDATA(simModel,realDataFName,simDataFName)
    %
    % simModel      - Here, a laser model.
    % realDataFName - Needed for state.
    % simDataFName  - Output file.
    
    debugFlag = false;
    
    load(realDataFName);
    clockLocal = tic();
    Y = simModel.predict(X);
    tComp = toc(clockLocal);
    if debugFlag
        fprintf('genSimData:Computation took %.2fs.',tComp);
    end
    
    save(simDataFName,'X','Y');
end