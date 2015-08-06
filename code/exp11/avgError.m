function err = avgError(XTrain,ZTrain,X,Z,lzr,bwX,bwZ,histDistance)
%AVGERROR Average error.
% 
% err = AVGERROR(XTrain,ZTrain,X,Z,lzr,bwX,bwZ,histDistance)
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
% err          - Error.

Q = length(Z);
[hArray,~] = ranges2Histogram(Z,lzr);
hPredArray = estimateHistogram(XTrain,ZTrain,X,lzr,bwX,bwZ);
err = zeros(1,Q);
for i = 1:Q
    err(i) = histDistance(hArray(i,:),hPredArray(i,:));
end
err = mean(err);
end

