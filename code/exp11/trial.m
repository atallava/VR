load bearing_1_data

%% Estimate
% bwX = 1e-2,bwZ = 5e-3
bwX = 0.2e-2; bwZ = 5e-3;
hId = 10;
[h,xc] = ranges2Histogram(ZHold{hId},lzr);
[hPred,xc] = estimateHistogram(XTrain,ZTrain,XHold(hId),lzr,bwX,bwZ);

%% Visualize
hf = vizHists(h,hPred,xc);


