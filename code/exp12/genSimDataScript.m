% generate simulated data for some input velocities

tag = 'traj';
dateStr = '150524';
index = '1';

%% load gt
fname = buildDataFileName('gt',tag,dateStr,index);
load(fname);

