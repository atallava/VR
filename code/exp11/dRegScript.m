% test distribution regression on single bearing data
load bearing_1_data

%% Estimate
bwX = 25e-3; bwZ = 10e-3;
hId = 10;
xc = getHistogramBins(lzr);
h = ranges2Histogram(ZHold{hId},lzr);
[hPred,xc] = estimateHistogram(XTrain,ZTrain,XHold(hId),lzr,bwX,bwZ);

%% Visualize
hf = vizHists(h,hPred,xc);

%% Calculate error
histDistance = @histDistanceEuclidean;
% histDistance = @histDistanceKL;
err = avgError(XTrain,ZTrain,XHold,ZHold,lzr,bwX,bwZ,histDistance);