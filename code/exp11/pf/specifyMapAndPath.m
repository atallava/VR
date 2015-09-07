% specify the map and path on which to generate data

%% load map
fNameMap = 'l_corridor';
load(fNameMap);
tp = trajPlanner(struct('file','trajectory_table.mat'));

%% use gui to get waypoints
clear th
map.plot();
[x,y] = ginput;
f = fit(x,y,'smoothingspline');
nPoints = length(x);
startTh = pi/2;
waypoints = zeros(3,nPoints);
waypoints(:,1) = [x(1); y(1); startTh;];
waypoints(1,2:end) = x(2:end);
waypoints(2,2:end) = feval(f,y(2:end));
th = differentiate(f,x(2:end));
th(th > pi) = th(th > pi)-2*pi;
th(th < -pi) = th(th < -pi)+2*pi;
th = [startTh; th];
for i = 2:length(th)
   th1 = th(i);
   if th1 > 0
       th2 = th1-pi;
   else
       th2 = th1+pi;
   end
   if abs(thDiff(th1,th(i-1))) < abs(thDiff(th2,th(i-1)))
       th(i) = th1;
   else
       th(i) = th2;
   end
end
waypoints(3,1:end) = th;

%% plan trajectory
traj = tp.planWithWaypoints(waypoints);

%% draw planned path
close all;
map.plot();
hold on;
plot(traj.poseArray(1,:),traj.poseArray(2,:));

%% save stuff
fname = 'pf_reference_traj';
save(fname,'map','traj');