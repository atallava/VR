% specify the map and path on which to generate data

%% load map
fNameMap = 'roomLineMap';
load(fNameMap);

%% use gui to get waypoints
map.plot();
[x,y] = ginput;
f = fit(x,y,'smoothingspline');
nPoints = length(x);
waypoints = zeros(3,nPoints);
waypoints(:,1) = [x(1); y(1); pi/2];
waypoints(1,2:end) = x(2:end);
waypoints(2,2:end) = feval(f,x(2:end));
th = differentiate(f,x(2:end));
waypoints(3,2:end) = th;

%% plan trajectory
tp = trajPlanner(struct('file','trajectory_table.mat'));
traj = tp.planWithWaypoints(waypoints);

%% draw planned path
close all;
map.plot();
hold on;
plot(traj.poseArray(1,:),traj.poseArray(2,:));

%% save stuff
fname = 'pf_reference';
save(fname,'map','traj');