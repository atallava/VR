% load files
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-sensor-modeling';
in.date = '150821'; 
in.index = '1';
fileName = buildDataFileName(in);
load(fileName);

in.tag = 'exp11-sensor-modeling-dreg-input';
fileName = buildDataFileName(in);
load(fileName);

in.tag = 'exp11-sensor-modeling-dreg-output';
fileName = buildDataFileName(in);
load(fileName);

%% helpers
histDistance = @histDistanceEuclidean;
[hArray,~] = ranges2Histogram(ZHold,sensor);

%% viz ranges
close all;
% pick id
id = 15;
pose = posesHold(:,id);
bearings = bearingsHold(pIdsHold == id);

% gt ranges
rangesGt = sampleFromHistogram(hArray(pIdsHold == id,:),xc,1);
riGt = rangeImage(struct('ranges',rangesGt,'bearings',bearings));
hfGt = riGt.plotXvsY(pose);
title('gt');
movegui(hfGt,'west');

% dreg ranges
rangesDReg = sampleFromHistogram(hPredArray(pIdsHold == id,:),xc,1);
riDReg = rangeImage(struct('ranges',rangesDReg,'bearings',bearings));
hfDReg = riDReg.plotXvsY(pose);
title('dReg');
movegui(hfDReg,'east');

%% viz hist
close all;
hId = randsample(find(pIdsHold == id),1);

% dReg
hf = vizHists(hArray(hId,:),hPredArray(hId,:),xc);
title('dReg');
suptitle(sprintf('bearing %.2f',rad2deg(bearingsHold(hId))));
movegui(hf,'center');

