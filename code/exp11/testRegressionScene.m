% test distribution regression on a scene
modifier = 'peta_240215';
v = '2';
fname = ['exp11_processed_data_' modifier];
load(fname);
fname = 'mats/processed_data_peta_240215';
load(fname);

%% Estimate
% CHECK PARAMETERS BEFORE ESTIMATING!
lzr = laserClass(struct());
bwX = [0.01 0.01 0.01];
% bwX = [0.03 0.03 0.08];
% bwX = [0.001 0.0644];
bwZ = 1e-3;
pId = 4; 
t1 = tic();
[hPred,xc] = estimateHistogram(XTrain,ZTrain,XHold(pIdsHold == pId,:),lzr,bwX,bwZ);
fprintf('Estimation took %.2fs\n',toc(t1));

%% Calculate error
[hArray,~] = ranges2Histogram(ZHold(pIdsHold == pId),lzr);
histDistance = @histDistanceKL;
Q = length(ZHold(pIdsHold == pId));
errVec = zeros(1,Q);
for i = 1:Q
    errVec(i) = histDistance(hArray(i,:),hPred(i,:));
end
err = mean(errVec);

%% Sample from histograms
ranges = sampleFromHistogram(hPred,xc,1);

%% Visualize
ri = rangeImage(struct('ranges',ranges,'bearings',bearingsHold(pIdsHold == pId)));
ri.plotXvsY(posesHold(:,pId));

%% Vizualize some histograms
hId = 49;
[h,~] = ranges2Histogram(ZHold{hId},lzr);
hf = vizHists(h,hPred(hId,:),xc);

%% Directly compute error
% histDistance = @histDistanceEuclidean;
histDistance = @histDistanceKL;
err = avgError(XTrain,ZTrain,XHold,ZHold,lzr,bwX,bwZ,histDistance);

%%
save('test_regression_scene.mat','XTrain','ZTrain','XHold','ZHold','bwX','bwZ','hPred','err');