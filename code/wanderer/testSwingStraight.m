%% initialize
if ~exist('rob','var')
    error('ROB MUST EXIST IN WORKSPACE');
end
if ~exist('map','var')
    error('MAP MUST EXIST IN WORKSPACE');
end
if ~exist('rstate','var')
    error('RSTATE MUST EXIST IN WORKSPACE');
end

% initialize objects
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser,'rob',rob,'rstate',rstate)); pause(1); 
vizerOD = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));
ctrlSt = controllerClass(struct());
ctrlSw = swingController(struct('kp',0.4,'ki',0.05));

%% test swing
%dThArray = deg2rad([-18:4:18]*10);
dThArray = deg2rad(90);
trueDThArray = zeros(size(dThArray));
trajFl = trajectoryFollower(struct('trajectory',[],'controller',ctrlSw));
for i = 1:length(dThArray)
    fprintf('%d...\n',i);
    start = rob.sim_robot.pose;
    st = swingTraj(start,dThArray(i));
    trajFl.resetTrajectory(st);
    trajFl.execute(rob,rstate);
    pause(0.01);
    goal = rob.sim_robot.pose;
    trueDThArray(i) = thDiff(goal(3),start(3));
end
eTh = thDiff(dThArray,trueDThArray);
fprintf('Finished.\n');

%% test straight
rob.sim_robot.pose = [0.5; 0.5; 0];
dist = 0.05;
dTh = deg2rad(5);
start = rob.sim_robot.pose;
st = straightTraj(start,dist);
trajFl = trajectoryFollower(struct('trajectory',st,'controller',ctrlSt));
pose = start+[0;0;dTh];
rob.sim_robot.pose = pose; rstate.reset(pose);
pause(1);
trajFl.execute(rob,rstate);
pause(1);
tg2d = pose2D(rob.sim_robot.pose);
err = tg2d.Tb2w\[st.goal(1); st.goal(2); 1];
fprintf('posn error: %f\n',norm(err(1:2)));
fprintf('psi error: %f\n',rad2deg(atan2(err(2),err(1))));

