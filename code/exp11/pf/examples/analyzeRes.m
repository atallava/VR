% fnameRes = '../data/npreg_exp/pf_res_npreg_exp_4_trial_10';
fnameRes = '../data/pf_npreg_res';
% fnameRes = '../data/pf_thrun_res';
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
% every odd measurement is an observation
ids = 2*(1:size(poseHistory,2))-1;
mleTraj = mleTraj(:,ids);

plot(mleTraj(1,:),mleTraj(2,:),'r');
quiver(mleTraj(1,:),mleTraj(2,:),...
    quiverScale*cos(mleTraj(3,:)),quiverScale*sin(mleTraj(3,:)),...
    'r','autoscale','off');
errVec = pose2D.poseNorm(poseHistory,mleTraj);

% % mean filter traj
% meanTraj = extractMeanTraj(particlesLog,weightsLog);
% % every odd measurement is an observation
% ids = 2*(1:size(poseHistory,2))-1;
% meanTraj = meanTraj(:,ids);
% 
% plot(meanTraj(1,:),meanTraj(2,:),'r');
% quiver(meanTraj(1,:),meanTraj(2,:),...
%     quiverScale*cos(meanTraj(3,:)),quiverScale*sin(meanTraj(3,:)),...
%     'r','autoscale','off');
% errVec = pose2D.poseNorm(poseHistory,meanTraj);

err = mean(errVec);
fprintf('Mean mle traj err: %.3f.\n',err);

%% sum of weights vs time
sumWeights = zeros(1,length(weightsLog));
for i = 1:length(weightsLog)
    sumWeights(i) = sum(weightsLog{i});
end

plot(sumWeights);
xlabel('time');
ylabel('particle sum weights');

%% particle diversity vs time
nUniqueParticles = zeros(1,length(weightsLog));
for i = 1:length(weightsLog)
    nUniqueParticles(i) = length(unique(weightsLog{i}));
end

plot(nUniqueParticles,'-+');
xlabel('time');
ylabel('particle diversity');
