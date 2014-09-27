clearAll
load reg_cov_map
load reg_cov_robot_poses

numScans = 50;
nPoses = size(poses,2);
%%
load sim_sep6_1
scans = cell(1,nPoses);
t1 = tic();
fprintf('Stats for sim...\n');
for i = 1:nPoses
    scans{i} = generateScansAtState(rsim,poses(:,i),map,numScans);
end
[bias,S] = computeRegCov(poses(:,1),scans,map);
save('sim_reg_cov','bias','S');
fprintf('Computation took %.2fs...\n',toc(t1));

%%
load sim_baseline
scans = cell(1,nPoses);
t1 = tic();
fprintf('Stats for baseline...\n');
for i = 1:nPoses
    scans{i} = generateScansAtState(rsim,poses(:,i),map,numScans);
end
[bias,S] = computeRegCov(poses(:,1),scans,map);
save('baseline_reg_cov','bias','S');
fprintf('Computation took %.2fs...\n',toc(t1));