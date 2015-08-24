function stats = evalDReg2(XTrain,ZTrain,X,Z,lzr,bwX,bwZ,histDistance)
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
[hCell,~,~] = rangesPairs2Histogram(Z,lzr);
hPredCell = estimateHistogram2(XTrain,ZTrain,X,lzr,bwX,bwZ);
err = zeros(1,Q);
for i = 1:Q
    err(i) = histDistance(hCell{i},hPredCell{i});
end
stats.err = err;
stats.meanErr = mean(err);
stats.hCell = hCell;
stats.hPredCell = hPredCell;
end

