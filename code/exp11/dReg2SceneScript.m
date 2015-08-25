% test dReg on a scene
% in.pre = 'data';
% in.source = 'sim-laser-gencal'; 
% in.tag = 'exp11-sensor-modeling-dreg';
% in.date = '150819'; 
% in.index = '';
% fname = buildDataFileName(in);

fname = 'exp11_processed_data2_peta_240215';
load(fname);
fname = 'processed_data_peta_240215';
load(fname);

%% Estimate
% CHECK PARAMETERS BEFORE ESTIMATING!
bwX = [0.01 0.01 0.01];
% bwX = [0.03 0.03 0.08];
% bwX = [0.001 0.0644];
bwZ = 1e-3;
pId = 1; 
t1 = tic();
[hPredCell,xc1,xc2] = estimateHistogram2(XTrain,ZTrain,XHold(pIdsHold == pId,:),sensor,bwX,bwZ);
fprintf('Estimation took %.2fs\n',toc(t1));

%% Calculate error
% for single pose
[hCell,~] = ranges2Histogram2(ZHold(pIdsHold == pId),sensor);
histDistance = @histDistanceKL;
Q = length(ZHold(pIdsHold == pId));
err = zeros(1,Q);
for i = 1:Q
    err(i) = histDistance(hCell{i},hPredCell{i});
end
meanErr = mean(err);

%% Sample from histograms
% assemble into range reading
[ranges,bearings] = sampleReadingFromHistogram2(hPredCell,xc1,xc2,bearingGroupsHold);

%% Visualize
ri = rangeImage(struct('ranges',ranges,'bearings',bearings));
hf = ri.plotXvsY(posesHold(:,pId));

%% Vizualize some histograms
histId = 49;
[h,~,~] = rangePairs2Histogram(ZHold{histId},sensor);
hf = vizHists(h,hPred{histId},xc1,xc2);

%% Evaluate on dataset
% histDistance = @histDistanceEuclidean;
histDistance = @histDistanceKL;
evalStats = evalDReg2(XTrain,ZTrain,XHold,ZHold,sensor,bwX,bwZ,histDistance);

%%
save('dreg2_scene.mat','XTrain','ZTrain','XHold','ZHold','sensor','bwX','bwZ','hPred','evalStats');

