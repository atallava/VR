% create traj planner
tp = trajPlanner();

%% get path
traj = spiralTrajFromGInput(tp);
pathStt = spiralTrajToAdesPath(traj);

%% save path
pathFname = 'path_1.txt';
saveAdesPath(pathStt,pathFname);