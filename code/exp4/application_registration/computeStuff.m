clearAll
load processed_data_sep14
load('nsh3_corridor','map')
load('params','numScans')

%% Our sim
poseIds = [1 6];
load('sim_sep6_2','rsim');
fprintf('Gathering results for sim...\n');
t1 = tic();
for i = 1:length(poseIds)
    poseRef = poses(:,poseIds(i));
    obsIds = randperm(length(obsArray{i,1}),numScans);
    scansReal = rangesFromObsArray(obsArray,poseIds(i),obsIds);
    resSim(i) = computeAlgoDifference(rsim,poseRef,scansReal,map);
end
fprintf('Computation took %.2fs.\n',toc(t1));

%% Baseline
poseIds = [1 6];
load('sim_baseline','rsim');
fprintf('Gathering results for baseline...\n');
t1 = tic();
for i = 1:length(poseIds)
    poseRef = poses(:,poseIds(i));
    obsIds = randperm(length(obsArray{i,1}),numScans);
    scansReal = rangesFromObsArray(obsArray,poseIds(i),obsIds);
    resBaseline(i) = computeAlgoDifference(rsim,poseRef,scansReal,map);
end
fprintf('Computation took %.2fs.\n',toc(t1));