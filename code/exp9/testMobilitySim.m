% test mobility simulator
% initialize variables
ctrl = controllerClass(struct('gainV',0,'gainW',0));
tfl = trajectoryFollower(struct('trajectory',[],'controller',ctrl));
tp = trajPlanner(struct('file','trajectory_table.mat'));

numTraj = 2;
startPoses = zeros(3,numTraj);
goalPoses = [1.5 2 -deg2rad(15); 2 -0.25 deg2rad(45)]';
assert(size(goalPoses,2) == numTraj,'N GOAL POSES NEEDED.');

%% execute trajectories

cond = logical(exist('rob','var'));
assert(cond,('ROB MUST EXIST IN WORKSPACE'));
assert(cond,('RSTATE MUST EXIST IN WORKSPACE'));
cond = isfield(rob.laser.data,'header');

poseHistory = cell(1,numTraj);
for i = 1:numTraj
	fprintf('Trajectory %d\n',i);
	rob.sim_robot.pose = startPoses(:,i);
	pause(0.5);
	rstate.reset(startPoses(:,i));
	pause(0.5);
	trajectory = tp.planPath(startPoses(:,i),goalPoses(:,i));
	tfl.resetTrajectory(trajectory);
	tfl.execute(rob,rstate);
	pause(0.5);
	poseHistory{i} = rstate.pose_history(:,1:rstate.motion_count-1);
end

