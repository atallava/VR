% generate simulated data for some input velocities

tag = 'traj';
dateStr = '150524';
index = '1';

%% load gt
fname = buildDataFileName('gt',tag,dateStr,index);
inputStruct = load(fname);
inputStruct.duration = inputStruct.tInputV(end)+1;
inputStruct.plotting = 1;
outputStruct = offlineNeato(inputStruct);
fname = buildDataFileName('sim',tag,dateStr,index);
save(fname,'-struct','outputStruct');

