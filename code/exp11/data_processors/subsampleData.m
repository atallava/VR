% input
in.pre = '../data';
in.source = 'neato-laser';
in.tag = 'exp11-sensor-modeling';
in.date = '140906'; 
in.index = '';
fname1 = buildDataFileName(in);
load(fname1);

%%
% subsample pose data
poseFrac = 1;
nTrainSub = ceil(poseFrac*length(trainIds));
nHoldSub = ceil(poseFrac*length(holdIds));
nTestSub = ceil(poseFrac*length(testIds));
trainIds = randsample(trainIds,nTrainSub);
% holdIds = randsample(holdIds,nHoldSub);
testIds = randsample(testIds,nTestSub);

% subsample sensor readings
obsFrac = 0.5;
obsArray = subsampleObsArray(obsArray,obsFrac);

%% output
in.index = 1;
fname2 = buildDataFileName(in);
copyfile(fname1,fname2);
save(fname2,'trainIds','holdIds','testIds','obsArray','-append');


