% test dReg on a scene
in.pre = 'data';
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150821'; 
in.index = '1';
fname = buildDataFileName(in);
load(fname);

% modifier = 'peta_240215';
% v = '2';
% fname = ['exp11_processed_data_' modifier];
% load(fname);
% fname = 'processed_data_peta_240215';
% load(fname);

%% Estimate
% CHECK PARAMETERS BEFORE ESTIMATING!
% bwX = [0.01 0.01 0.01];
% bwX = [0.05 0.05 0.1];
bwX = [0.01 0.0644];
bwZ = 1e-3;
pId = 1; 
t1 = tic();
[hPredArray,xc] = estimateHistogram(XTrain,ZTrain,XHold(pIdsHold == pId,:),sensor,bwX,bwZ);
fprintf('Estimation took %.2fs\n',toc(t1));

%% Calculate error
% for small dataset typically
xc = getHistogramBins(sensor);
hArray = ranges2Histogram(ZHold(pIdsHold == pId),xc);
histDistance = @histDistanceMatch;
[meanErr,err] = evalHPred(hArray,hPredArray,histDistance);

%% Sample from histograms
ranges = sampleFromHistogram(hPredArray,xc,1);

%% Visualize
ri = rangeImage(struct('ranges',ranges,'bearings',bearingsHold(pIdsHold == pId)));
hf = ri.plotXvsY(posesHold(:,pId));

%% Vizualize some histograms
hId = 5;
h1 = ranges2Histogram(ZHold{hId},xc);
h2 = hPredArray(hId,:);
hf = vizHists(h1,h2,xc);
err = histDistance(h1,h2);

%% Evaluate on dataset
% histDistance = @histDistanceEuclidean;
histDistance = @histDistanceKL;
hArray = ranges2Histogram(ZHold,sensor);
hPredArray = estimateHistogram(XTrain,ZTrain,XHold,sensor,bwX,bwZ);
[meanErr,err] = evalHPred(hArray,hPredArray,histDistance);

%%
save('dreg_scene.mat','XTrain','ZTrain','XHold','ZHold','sensor','bwX','bwZ','hPred','evalStats');

