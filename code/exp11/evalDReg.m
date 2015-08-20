function stats = evalDReg(XTrain,ZTrain,X,Z,lzr,bwX,bwZ,histDistance)
%EVALDREG Evaluate distribution regression on dataset.
% 
% err = EVALDREG(XTrain,ZTrain,X,Z,lzr,bwX,bwZ,histDistance)
% 
% XTrain       - N x dimX array.
% ZTrain       - length N cell array.
% X            - Q x dimX array.
% Z            - length Q cell array.
% lzr          - laserClass object.
% bwX          - Bandwidth.
% bwZ          - Bandwidth.
% histDistance - Handle to histogram distance.
% 
% stats        - Performance statistics. Struct.

Q = length(Z);
[hArray,~] = ranges2Histogram(Z,lzr);
hPredArray = estimateHistogram(XTrain,ZTrain,X,lzr,bwX,bwZ);
err = zeros(1,Q);
for i = 1:Q
    err(i) = histDistance(hArray(i,:),hPredArray(i,:));
end
stats.err = err;
stats.meanErr = mean(err);
stats.hArray = hArray;
stats.hPredArray = hPredArray;
end

