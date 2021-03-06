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
traj = sTraj;
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
flag = tfl.tLog ~= 0;
tInputV = tfl.tLog(flag)+tfl.tOffset;
inputVlLog = tfl.vlLog(flag);
inputVrLog = tfl.vrLog(flag);

%% save to file
robotName = 'peta';
tag = 'traj';
dateStr = yymmddDate();
index = 10;
fname = buildDataFileName(robotName,tag,dateStr,index);
fname = ['data/' fname];
save(fname,'enc','lzr','inputVlLog','inputVrLog','tInputV','tStartTraj','tStopTraj','traj');
