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
bwX = [0.001 0.02];
bwZ = 1e-3;

% preg cannot handle more data
% putting dreg on the same footing
n = 1000;
ids = randsample(1:length(ZTrain),n);
XTrain = XTrain(ids,:);
ZTrain = ZTrain(ids);

clockLocal = tic();
[hDReg,xc] = estimateHistogram(XTrain,ZTrain,XHold((pIdsHold == pId),:),sensor,bwX,bwZ);
hGt = ranges2Histogram(ZHold(pIdsHold == pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @histDistanceMatch;
err = histDistance(hGt,hDReg);

%% visualize scan
close all;
pose = posesHold(:,pId);
bearings = bearingsHold(pIdsHold == pId);

rangesGt = sampleFromHistogram(hGt,xc,1);
riGt = rangeImage(struct('ranges',rangesGt,'bearings',bearings));
hfGt = riGt.plotXvsY(pose);
title('gt');
movegui(hfGt,'west');

rangesDReg = sampleFromHistogram(hDReg,xc,1);
riDReg = rangeImage(struct('ranges',rangesDReg,'bearings',bearings));
hfDReg = riDReg.plotXvsY(pose);
title('dreg');
movegui(hfDReg,'east');

%% visualize histogram
close all;
hId = randsample(1:size(hGt,1),1);
h1 = hGt(hId,:);
h2 = hDReg(hId,:);
hf = vizHists(h1,h2,xc);
