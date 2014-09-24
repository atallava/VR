load dataset_rangenorm
laserPose = [1.87;1.97;0];

%% Baseline simulator
load sim_baseline;
scans = generateSimulatedScans(rsim,confList,laserPose,30);

%% Baseline simulator
load sim_sep6_1;
scans = generateSimulatedScans(rsim,confList,laserPose,30);
