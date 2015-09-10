% input
in.pre = '../data/';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150821'; 
in.index = '1';
fname1 = buildDataFileName(in);
load(fname1);

%%
% subsample pose data
frac = 0.7;

% test
trainIdsSub = randsample(1:length(ZTrain),ceil(frac*length(ZTrain)));
XTrain = XTrain(trainIdsSub,:);
pIdsTrain = pIdsTrain(trainIdsSub);
bearingsTrain = bearingsTrain(trainIdsSub);
ZTrain = ZTrain(trainIdsSub);

% hold
holdIdsSub = randsample(1:length(ZHold),ceil(frac*length(ZHold)));
XHold = XHold(holdIdsSub,:);
pIdsHold = pIdsHold(holdIdsSub);
bearingsHold = bearingsHold(holdIdsSub);
ZHold = ZHold(holdIdsSub);

% test 
testIdsSub = randsample(1:length(ZTest),ceil(frac*length(ZTest)));
XTest = XTest(testIdsSub,:);
pIdsTest = pIdsTest(testIdsSub);
bearingsTest = bearingsTest(testIdsSub);
ZTest = ZTest(testIdsSub);

%% output
in.index = 2;
fname2 = buildDataFileName(in);
copyfile(fname1,fname2);
save(fname2,...
    'XTrain','pIdsTrain','bearingsTrain','ZTrain',...
    'XHold','pIdsHold','bearingsHold','ZHold',...
    'XTest','pIdsTest','bearingsTest','ZTest','-append');


