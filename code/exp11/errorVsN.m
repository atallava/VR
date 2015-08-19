% find how error varies with number of training samples
clearAll;
load data/bearing_1_data.mat
X = [XTrain; XHold];
Z = [ZTrain ZHold];

%% 
% fraction of data to hold out
p = [0.1 0.3 0.5 0.7 0.9];
nRuns = 10;

[bwXArray,bwZArray] = meshgrid([1e-3 5e-3 1e-2 5e-2],[1e-3 5e-3 1e-2 5e-2]);
bwXArray = bwXArray(:); bwZArray = bwZArray(:);
histDistance = @histDistanceEuclidean;

[bwXOpt,bwZOpt,err] = deal(zeros(length(p),nRuns));

t1 = tic();
for i = 1:length(p)
    fprintf('p: %.2f\n',p(i));
    for j = 1:nRuns
        fprintf('run %d\n',j);
        [trainIds,holdIds] = crossvalind('HoldOut',size(X,1),p(i));
        X1 = X(trainIds,:); Z1 = Z(trainIds);
        X2 = X(holdIds,:); Z2 = Z(holdIds);
        
        errFn = @(bwX,bwZ) avgError(X1,Z1,X2,Z2,lzr,bwX,bwZ,histDistance);
        bwErr = getBwErr(bwXArray,bwZArray,errFn);
                
        [minErr,minId] = min(bwErr);
        err(i,j) = minErr;
        bwXOpt(i,j) = bwXArray(minId);
        bwZOpt(i,j) = bwZArray(minId);
    end
end
avgErr = mean(err,2);
fprintf('Computation took %.2fs.\n',toc(t1));


%%
save('error_vs_n','p','err','bwXOpt','bwZOpt','avgErr');