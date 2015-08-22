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
poseFrac = 0.16;
trainIds = randsample(trainIds,ceil(poseFrac*length(trainIds)));
holdIds = randsample(holdIds,ceil(poseFrac*length(holdIds)));
testIds = randsample(testIds,ceil(poseFrac*length(testIds)));

% subsample sensor readings
obsFrac = 0.5;
obsArray = subsampleObsArray(obsArray,obsFrac);

%% output
in.index = 3;
fname2 = buildDataFileName(in);
copyfile(fname1,fname2);
save(fname2,'trainIds','holdIds','testIds','obsArray','-append');


