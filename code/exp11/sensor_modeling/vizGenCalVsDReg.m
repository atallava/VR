% load files
in.source = 'neato-laser'; 
in.tag = 'exp11-sensor-modeling-perf-ntrain';
in.date = '140906'; 
in.index = '1';
fileName = buildDataFileName(in);
load(fileName);

in.tag = 'exp11-sensor-modeling';
fileName = buildDataFileName(in);
load(fileName);

in.tag = 'exp11-sensor-modeling-dreg-input';
fileName = buildDataFileName(in);
load(fileName);

%%
% pick a set of histogram estimates
hPredGenCal = hPredCellGenCal{1};
hPredDReg = hPredCellDReg{4};

%% viz ranges
close all;
% pick field point
id = 12;
pose = posesTest(:,id);
bearings = bearingsTest(pIdsTest == id);

% gt ranges
rangesGt = sampleFromHistogram(hArrayGt(pIdsTest == id,:),xc,1);
riGt = rangeImage(struct('ranges',rangesGt,'bearings',bearings));
hfGt = riGt.plotXvsY(pose);
title('gt');
movegui(hfGt,'center');

% comparator ranges
rangesGenCal = sampleFromHistogram(hPredGenCal(pIdsTest == id,:),xc,1);
riGenCal = rangeImage(struct('ranges',rangesGenCal,'bearings',bearings));
hfGenCal = riGenCal.plotXvsY(pose);
title('gencal');
movegui(hfGenCal,'west');

% dReg ranges
rangesDReg = sampleFromHistogram(hPredDReg(pIdsTest == id,:),xc,1);
riDReg = rangeImage(struct('ranges',rangesDReg,'bearings',bearings));
hfDReg = riDReg.plotXvsY(pose);
title('dReg');
movegui(hfDReg,'east');

%% viz hist
close all;
hId = randsample(find(pIdsTest == id),1);

% comparator
hf1 = vizHists(hArrayGt(hId,:),hPredGenCal(hId,:),xc);
suptitle('gencal');
movegui(hf1,'west');

% dReg
hf2 = vizHists(hArrayGt(hId,:),hPredDReg(hId,:),xc);
suptitle('dReg');
movegui(hf2,'east');

