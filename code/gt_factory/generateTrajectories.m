% trajectories for neato
tp = trajPlanner(struct('file','trajectory_table.mat'));
ctrl = controllerClass(struct('gainV',0,'gainW',0));
tfl = trajectoryFollower(struct('trajectory',[],'controller',ctrl));

%% straight line trajectory
stlineTraj = tp.planPath([0; 0; 0], [1; 0; 0]);

%% s-shaped trajectory
sWaypoints = [[0; 0; 0], [1.5/3; 0.3; 0], [2/3*1.5; -0.3; 0], [1.5; 0; 0]];
sTraj = tp.planWithWaypoints(sWaypoints);

%%
save('motion_vars','tp','ctrl','tfl','stlineTraj','sWaypoints','sTraj');
