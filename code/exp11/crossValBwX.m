fname = 'bearing_1_data';
load(fname);

%%
bwZ = 1e-3;
nBwX = 10;
bwXArray = 10.^linspace(-3,0,nBwX);
nHold = length(ZHold);

t1 = tic();
[hHoldArray,xc] = ranges2Histogram(ZHold,lzr);
bwXErr = zeros(1,nBwX);
for i = 1:length(bwXArray)
    bwX = bwXArray(i);
    fprintf('bwX: %.2f\n',bwX);
    hPredArray = estimateHistogram(XTrain,ZTrain,XHold,lzr,bwX,bwZ);
    err = 0;
    for j = 1:nHold
        err = err+histDistance(hHoldArray(j,:),hPredArray(j,:));
    end
    bwXErr(i) = err/nHold;
end
fprintf('Computation took %.2fs\n',toc(t1));

[~,minId] = min(bwXErr);
bwXOpt = bwXArray(minId); % = 0.0046

