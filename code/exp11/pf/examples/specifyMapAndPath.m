% specify the map and path on which to generate data

%% load map
fNameMap = 'l_corridor';
load(fNameMap);
load([fNameMap '_support']);
tp = trajPlanner();

%% get path
traj = spiralTrajFromGInput(tp);
pathStt = spiralTrajToAdesPath(traj);

%% draw planned path
close all;
map.plot();
hold on;
plot(traj.poseArray(1,:),traj.poseArray(2,:));

%% save stuff
fname = 'pf_reference_traj';
save(fname,'map','support','traj');