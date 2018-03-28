% viz some real and estimated trajectories

%% load
suffix = 1; % [1-4]. i forgot what it meant
nRuns = 20;
runId = randsample(nRuns,1);
fprintf('run id: %d\n', runId);

load(sprintf('../data/real_reg_filters_%d', suffix), 'rflArray');
realPoses = rflArray(runId).poseArray;

load(sprintf('../data/sim_reg_filters_%d', suffix), 'rflArray');
ourPoses = rflArray(runId).poseArray;

load(sprintf('../data/baseline_reg_filters_%d', suffix), 'rflArray');
baselinePoses = rflArray(runId).poseArray;

% map
load('../data/b100_padded_corridor.mat', 'map');

%% viz
hfig = figure; hold on; axis equal;
lineWidth = 3;

plot(realPoses(1,:), realPoses(2,:), ...
    'linewidth', lineWidth);
plot(ourPoses(1,:), ourPoses(2,:), ...
    'linewidth', lineWidth);
plot(baselinePoses(1,:), baselinePoses(2,:), ...
    'linewidth', lineWidth);

% legendStr = {'real','our approach','baseline'};
% legend(legendStr);

for obj = map.objects
    plot(obj.line_coords(:,1), obj.line_coords(:,2),...
        'Color', 'b', 'linewidth', lineWidth);
end

xlim([-2.7245    3.8965]); ylim([-1.5    1.5500]);

xlabel('x (m)'); ylabel('y (m)');
fontSize = 15;
set(gca, 'fontSize', fontSize);