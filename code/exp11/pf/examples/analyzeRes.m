fnameRes = '../data/pf_res';
load(fnameRes);

%%
map.plot();
hold on;

% true traj
plot(poseHistory(1,:),poseHistory(2,:),'b');
quiverScale = 0.1;
quiver(poseHistory(1,:),poseHistory(2,:),...
    quiverScale*cos(poseHistory(3,:)),quiverScale*sin(poseHistory(3,:)),...
    'b','autoscale','off');
    
% filter traj
mleTraj = extractMleTraj(particlesLog,weightsLog);
plot(mleTraj(1,:),mleTraj(2,:),'r');
quiver(mleTraj(1,:),mleTraj(2,:),...
    quiverScale*cos(mleTraj(3,:)),quiverScale*sin(mleTraj(3,:)),...
    'r','autoscale','off');