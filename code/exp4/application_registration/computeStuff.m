clearAll
load processed_data_sep25_registration
load('nsh3_corridor','map')
load('params','numScans')

%% Our sim
poseIds = [1 2];
load('sim_sep6_1','rsim');
fprintf('Gathering results for sim...\n');
t1 = tic();
for i = 1:length(poseIds)
    fprintf('Pose %d...\n',i);
    poseRef = poses(:,poseIds(i));
    obsIds = randperm(length(obsArray{i,1}),numScans);
    scansReal = rangesFromObsArray(obsArray,poseIds(i),obsIds);
    resSim(i) = computeAlgoDifference(rsim,poseRef,scansReal,map);
end
fprintf('Computation took %.2fs.\n',toc(t1));

%% Baseline
poseIds = [1 2];
load('sim_baseline','rsim');
fprintf('Gathering results for baseline...\n');
t1 = tic();
for i = 1:length(poseIds)
    fprintf('Pose %d...\n',i);
    poseRef = poses(:,poseIds(i));
    obsIds = randperm(length(obsArray{i,1}),numScans);
    scansReal = rangesFromObsArray(obsArray,poseIds(i),obsIds);
    resBaseline(i) = computeAlgoDifference(rsim,poseRef,scansReal,map);
end
fprintf('Computation took %.2fs.\n',toc(t1));

%%
save('res_sim_sep25','resSim');
save('res_baseline_sep25','resBaseline');