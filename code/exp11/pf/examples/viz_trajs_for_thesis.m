% real and estimated trajectories

%% load traj
nTrials = 30;

% fnamePre = '../data/npreg_exp/pf_res_npreg';
% expId = 1; trialId = randsample(nTrials, 1);

fnamePre = '../data/thrun_exp/pf_res_thrun';
expId = 4; trialId = randsample(nTrials, 1);

fprintf('exp id: %d, trial id: %d\n', expId, trialId);
fname = sprintf('%s_exp_%d_trial_%d',fnamePre,expId,trialId);

load(fname, 'poseHistory', 'particlesLog', 'weightsLog', 'map');
mleTraj = extractMleTraj(particlesLog, weightsLog);

%% viz
hfig = figure; axis equal; hold on;
lineWidth = 2;

plot(poseHistory(1,:), poseHistory(2,:), ...
    'linewidth', lineWidth);
plot(mleTraj(1,:), mleTraj(2,:), ...
    '--', 'linewidth', lineWidth);

% for obj = map.objects
%     plot(obj.line_coords(:,1), obj.line_coords(:,2),...
%         'Color', 'b', 'linewidth', lineWidth);
% end

xlabel('x (m)'); ylabel('y (m)');
legend('ground truth', 'estimated trajectory');