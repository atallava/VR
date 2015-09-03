function [bwXOpt,bwZOpt] = holdoutBwDRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance)
    % function version of script
    % useful in evaluating performance versus training data
    
    % specify bw range
    nBwX = 10;
    nBwZ = 10;
    limsBwX = [0.1 40];
    limsBwZ = [0.05 5];
    [bwXArray,bwZArray] = meshgrid(linspace(limsBwX(1),limsBwX(2),nBwX),linspace(limsBwZ(1),limsBwZ(2),nBwZ));
    bwXArray = bwXArray(:);
    bwZArray = bwZArray(:);
    
    xc = getHistogramBins(sensor);    
    % estimate histograms
    bwMeanErr = zeros(1,length(bwXArray));
    hArray = ranges2Histogram(ZHold,xc);
    
    for i = 1:length(bwXArray)
        bwX = bwXArray(i);
        bwZ = bwZArray(i);
        hPredArray = estimateHistogram(XTrain,ZTrain,XHold,sensor,bwX,bwZ);
        [bwMeanErr(i),err] = evalHPred(hArray,hPredArray,histDistance);
    end
    
    [minErr,minId] = min(bwMeanErr);
    bwXOpt = bwXArray(minId); bwZOpt = bwZArray(minId);
end