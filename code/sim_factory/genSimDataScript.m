% generate simulated data corresponding to ground truth data
% load gt
inputStruct.pre = 'data/';
inputStruct.source = 'gt';
inputStruct.tag = 'traj';
inputStruct.date = '150804';
inputStruct.index = '5';

fname = buildDataFileName(inputStruct);
load(fname);

%% load gt
fname = buildDataFileName('gt',tag,dateStr,index);
inputStruct = load(fname);
inputStruct.duration = inputStruct.tInputV(end)+1;
inputStruct.plotting = 1;
outputStruct = offlineNeato(inputStruct);
fname = buildDataFileName('sim',tag,dateStr,index);
save(fname,'-struct','outputStruct');

