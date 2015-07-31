% code to run on neato
% initialize
cond = logical(exist('rob','var'));
assert(cond,('ROB MUST EXIST IN WORKSPACE'));
cond = logical(exist('rstate','var'));
assert(cond,('RSTATE MUST EXIST IN WORKSPACE'));
cond = isfield(rob.laser.data,'header');
assert(cond,'LASER MUST BE ON!');

load motion_vars

%% execute trajectory
traj = stlineTraj;
tfl.resetTrajectory(traj);
pause(0.5);
rstate.reset([0; 0; 0]); % reset to zero
pause(0.5);

clear enc lzr
clockLocal = tic();
enc = encHistory(rob,clockLocal);
lzr = laserHistory(rob,clockLocal);
tStartTraj = toc(clockLocal);
tfl.execute(rob,rstate,clockLocal);
tStopTraj = toc(clockLocal);
enc.stopListening();
lzr.stopListening();
pause(0.5);
% input commands history
tInputOffset = tfl.tLocalRelative;
vlArray = tfl.vlLog; vrArray = tfl.vrLog;
inputTArray = tfl.tLog;

%% save to file
fname = 'data_peta_traj_150524_10';
save(fname,'enc','lzr','vlArray','vrArray','inputTArray','tStartTraj','tStopTraj','tInputOffset','traj');
