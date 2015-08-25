% input
in.pre = '../data';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-mapping';
in.date = '150821'; 
in.index = '1';
fname1 = buildDataFileName(in);
load(fname1);

%%
% subsample pose data
poseFrac = 0.5;
% nTrainSub = ceil(poseFrac*length(trainIds));
nTrainSub = 100;
nHoldSub = ceil(poseFrac*length(holdIds));
nTestSub = ceil(poseFrac*length(testIds));
trainIds = randsample(trainIds,nTrainSub);
holdIds = randsample(holdIds,nHoldSub);
testIds = randsample(testIds,nTestSub);

% subsample sensor readings
obsFrac = 0.5;
obsArray = subsampleObsArray(obsArray,obsFrac);

%% output
in.index = 4;
fname2 = buildDataFileName(in);
copyfile(fname1,fname2);
save(fname2,'trainIds','holdIds','testIds','obsArray','-append');


