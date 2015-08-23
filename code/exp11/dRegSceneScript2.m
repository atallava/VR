% test dReg on a scene
% in.pre = 'data';
% in.source = 'sim-laser-gencal'; 
% in.tag = 'exp11-sensor-modeling-dreg';
% in.date = '150819'; 
% in.index = '';
% fname = buildDataFileName(in);

modifier = 'peta_240215';
v = '2';
fname = ['exp11_processed_data_' modifier];
load(fname);
fname = 'data/processed_data_peta_240215';
load(fname);

%% Estimate
% CHECK PARAMETERS BEFORE ESTIMATING!
bwX = [0.01 0.01 0.01];
% bwX = [0.03 0.03 0.08];
% bwX = [0.001 0.0644];
bwZ = 1e-3;
pId = 4; 
t1 = tic();
[hPred,xc] = estimateHistogram2(XTrain,ZTrain,XHold(pIdsHold == pId,:),sensor,bwX,bwZ);
fprintf('Estimation took %.2fs\n',toc(t1));

%% Calculate error
% for small dataset typically
[hArray,~] = ranges2Histogram(ZHold(pIdsHold == pId),sensor);
histDistance = @histDistanceKL;
Q = length(ZHold(pIdsHold == pId));
err = zeros(1,Q);
for i = 1:Q
    err(i) = histDistance(hArray(i,:),hPred(i,:));
end
meanErr = mean(err);

%% Sample from histograms
ranges = sampleFromHistogram(hPred,xc,1);

%% Visualize
ri = rangeImage(struct('ranges',ranges,'bearings',bearingsHold(pIdsHold == pId)));
hf = ri.plotXvsY(posesHold(:,pId));

%% Vizualize some histograms
histId = 49;
[h,~] = ranges2Histogram(ZHold{histId},sensor);
hf = vizHists(h,hPred(histId,:),xc);

%% Evaluate on dataset
% histDistance = @histDistanceEuclidean;
histDistance = @histDistanceKL;
evalStats = evalDReg(XTrain,ZTrain,XHold,ZHold,sensor,bwX,bwZ,histDistance);

%%
save('test_regression_scene.mat','XTrain','ZTrain','XHold','ZHold','sensor','bwX','bwZ','hPred','evalStats');

