% find how error varies with number of Z 
clearAll;
load mats/bearing_1_data.mat

%% 
% fraction of data to hold out
p = [0.1 0.3 0.5 0.7 0.9];
nRuns = 10;

% get max M.
maxM = zeros(1,length(ZTrain));
for i = 1:length(ZTrain); maxM(i) = length(ZTrain{i}); end
maxM = min(maxM);

[bwXArray,bwZArray] = meshgrid([1e-3 5e-3 1e-2 5e-2],[1e-3 5e-3 1e-2 5e-2]);
bwXArray = bwXArray(:); bwZArray = bwZArray(:);
histDistance = @histDistanceEuclidean;

[bwXOpt,bwZOpt,err] = deal(zeros(length(p),nRuns));

t1 = tic();
for i = 1:length(p)
    fprintf('p: %.2f\n',p(i));
    for j = 1:nRuns
        fprintf('run %d\n',j);
        [trainIds,holdIds] = crossvalind('HoldOut',maxM,p(i));
        
        ZTrainP = cell(1,length(ZTrain));
        for k = 1:length(ZTrain)
            z = ZTrain{k};
            ZTrainP{k} = z(trainIds);
        end
        
        errFn = @(bwX,bwZ) avgError(XTrain,ZTrainP,XHold,ZHold,lzr,bwX,bwZ,histDistance);
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
save('error_vs_m','p','err','bwXOpt','bwZOpt','avgErr');