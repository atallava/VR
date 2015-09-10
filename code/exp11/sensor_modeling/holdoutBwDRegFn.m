function [bwX1Opt,bwX2Opt] = holdoutBwDRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance)
    % function version of script
    % useful in evaluating performance versus training data
    
    % specify bw range
    nBwX1 = 5;
    nBwX2 = 5;
    limsBwX1 = [0.001 0.02];
    limsBwX2 = [0.008 0.0873];
    [bwX1Array,bwX2Array] = meshgrid(linspace(limsBwX1(1),limsBwX1(2),nBwX1),linspace(limsBwX2(1),limsBwX2(2),nBwX2));
    bwX1Array = bwX1Array(:);
    bwX2Array = bwX2Array(:);
    
    % estimate histograms
    xc = getHistogramBins(sensor);
    bwMeanErr = zeros(1,length(bwX1Array));
    hArray = ranges2Histogram(ZHold,xc);
    bwZ = 1e-3;
    
    localClock = tic();
    for i = 1:length(bwX1Array)
        bwX1 = bwX1Array(i);
        bwX2 = bwX2Array(i);
        bwX = [bwX1 bwX2];
        hPredArray = estimateHistogram(XTrain,ZTrain,XHold,sensor,bwX,bwZ);
        [bwMeanErr(i),err] = evalHPred(hArray,hPredArray,histDistance);
    end
    compTime = toc(localClock);
    
    [minErr,minId] = min(bwMeanErr);
    bwX1Opt = bwX1Array(minId); bwX2Opt = bwX2Array(minId);
 end