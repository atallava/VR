% when i don't have the time to write a structured evaluation
in.source = 'neato-laser'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '140906'; 
in.index = '1';
fileName = buildDataFileName(in);
load(fileName);

%% estimate at one pose only
% CHECK PARAMETERS BEFORE ESTIMATING!
pId = 1;
bwXMu = [0.5053 0.3252];
bwXSigma = [0.2639 0.3514];
bwXList = {bwXMu bwXSigma};
bwZ = 1e-3;

% preg cannot handle more data
n = 1000;
ids = randsample(1:length(ZTrain),n);
XTrain = XTrain(ids,:);
ZTrain = ZTrain(ids);

clockLocal = tic();
[hPReg,xc] = estimateHistogramGaussian(XTrain,ZTrain,XHold((pIdsHold == pId),:),sensor,bwXList);
hGt = ranges2Histogram(ZHold(pIdsHold == pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @histDistanceMatch;
err = histDistance(hGt,hPReg);

%% visualize scan
close all;
pose = posesHold(:,pId);
bearings = bearingsHold(pIdsHold == pId);

rangesGt = sampleFromHistogram(hGt,xc,1);
riGt = rangeImage(struct('ranges',rangesGt,'bearings',bearings));
hfGt = riGt.plotXvsY(pose);
title('gt');
movegui(hfGt,'west');

rangesPReg = sampleFromHistogram(hPReg,xc,1);
riPReg = rangeImage(struct('ranges',rangesPReg,'bearings',bearings));
hfPReg = riPReg.plotXvsY(pose);
title('preg');
movegui(hfPReg,'east');

%% visualize histogram
close all;
hId = randsample(1:size(hGt,1),1);
h1 = hGt(hId,:);
h2 = hPReg(hId,:);
hf = vizHists(h1,h2,xc);
