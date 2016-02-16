% create traj planner
tp = trajPlanner();

%% get path
traj = spiralTrajFromGInput(tp);
pathStt = spiralTrajToAdesPath(traj);

%% save path
pathFname = '../data/path_1.txt';
saveDesiredPath(pathStt,pathFname);