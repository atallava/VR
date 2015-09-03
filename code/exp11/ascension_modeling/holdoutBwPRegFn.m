function bwXListOpt = holdoutBwPRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance)
    % function version of script
    % useful in evaluating performance versus training data
    
    % specify bw range
    nBwXMu = 10;
    nBwXSigma = 10;
    limsBwXMu = [0.1 40];
    limsBwXSigma = [0.1 40];
    [bwXMuArray,bwXSigmaArray] = meshgrid(linspace(limsBwXMu(1),limsBwXMu(2),nBwXMu),linspace(limsBwXSigma(1),limsBwXSigma(2),nBwXSigma));
    bwXMuArray = bwXMuArray(:);
    bwXSigmaArray = bwXSigmaArray(:);
    
    % estimate histograms
    xc = getHistogramBins(sensor);
    bwMeanErr = zeros(1,length(bwXMuArray));
    [hArray,~] = ranges2Histogram(ZHold,xc);
    
    for i = 1:length(bwXMuArray)
        bwXMu = bwXMuArray(i);
        bwXSigma = bwXSigmaArray(i);
        bwXList = {bwXMu bwXSigma};
        hPredArray = estimateHistogramGaussian(XTrain,ZTrain,XHold,sensor,bwXList);
        [bwMeanErr(i),err] = evalHPred(hArray,hPredArray,histDistance);
    end
    
    [minErr,minId] = min(bwMeanErr);
    bwXMuOpt = bwXMuArray(minId); bwXSigmaOpt = bwXSigmaArray(minId);
    bwXListOpt = {bwXMuOpt bwXSigmaOpt};
end