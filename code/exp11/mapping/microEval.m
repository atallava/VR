% when i don't have the time to write a structured evaluation
in.pre = 'data';
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-mapping-dreg-input';
in.date = '150821'; 
in.index = '4';
fname = buildDataFileName(in);
load(fname);

%% estimate at one pose only
% CHECK PARAMETERS BEFORE ESTIMATING!
pId = 2;
% bwX = [0.05 0.05 0.0349];
bwX = [0.1667 0.1667 0.0524];
bwZ = 1e-3;

clockLocal = tic();
% [hDReg,xc] = estimateHistogramSmoothing(XTrain,ZTrain,XHold(pIdsHold == pId,:),sensor,bwX,bwZ);
[hDReg,xc] = estimateHistogram(XTrain,ZTrain,XHold(pIdsHold == pId,:),sensor,bwX,bwZ);
hGt = ranges2Histogram(ZHold(pIdsHold == pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @histDistanceKL;
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
vizHists(hGt(hId,:),hDReg(hId,:),xc);