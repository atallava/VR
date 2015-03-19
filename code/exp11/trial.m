load bearing_1_data

%% Estimate
bwX = 1e-2; bwZ = 1e-3;
[h,xc] = ranges2Histogram(ZHold{1},lzr);
[hPred,xc] = estimateHistogram(XTrain,ZTrain,XHold(1),lzr,bwX,bwZ);

%% Visualize
hf = vizHists(h,hPred,xc);


