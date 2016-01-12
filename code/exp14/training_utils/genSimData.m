function datasetSim = genSimData(simModel,datasetReal)
    %GENSIMDATA Wrapper around model prediction.
    %
    % GENSIMDATA(simModel,datasetReal)
    %
    % simModel      - 
    % datasetReal - Struct array with fields ('X','Y').
    % datasetSim  - Struct array with fields ('X','Y').
    
    debugFlag = true;
    
    datasetSim = datasetReal;
    clockLocal = tic();
    nElements = length(datasetReal);
    for i = 1:nElements
        datasetSim(i).Y = simModel.predict(datasetSim(i).X);
    end
    tComp = toc(clockLocal);
    if debugFlag
        fprintf('genSimData:Computation time: %.2fs.\n',tComp);
    end
end