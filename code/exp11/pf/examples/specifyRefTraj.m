% load map
fnameMap = '../data/wide_corridor';
load(fnameMap,'map');

% create traj planner
tp = trajPlanner();

%% get path
hf = map.plot;
traj = spiralTrajFromGInput(tp,hf);

%%
fnameRefTraj = '../data/wide_corridor_s_traj';
save(fnameRefTraj,'traj');