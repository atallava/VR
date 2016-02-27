% fnameRes = '../data/pf_npreg_res';
fnameRes = '../data/pf_thrun_res';
load(fnameRes);

%% plot trajectories
map.plot();
hold on;

% true traj
plot(poseHistory(1,:),poseHistory(2,:),'b');
quiverScale = 0.1;
quiver(poseHistory(1,:),poseHistory(2,:),...
    quiverScale*cos(poseHistory(3,:)),quiverScale*sin(poseHistory(3,:)),...
    'b','autoscale','off');
    
% mle filter traj
mleTraj = extractMleTraj(particlesLog,weightsLog);
plot(mleTraj(1,:),mleTraj(2,:),'r');
quiver(mleTraj(1,:),mleTraj(2,:),...
    quiverScale*cos(mleTraj(3,:)),quiverScale*sin(mleTraj(3,:)),...
    'r','autoscale','off');

%% sum of weights vs time
sumWeights = zeros(1,length(weightsLog));
for i = 1:length(weightsLog)
    sumWeights(i) = sum(weightsLog{i});
end

plot(sumWeights);

%% particle diversity vs time
nUniqueParticles = zeros(1,length(weightsLog));
for i = 1:length(weightsLog)
    nUniqueParticles(i) = length(unique(weightsLog{i}));
end

plot(nUniqueParticles,'-+');
