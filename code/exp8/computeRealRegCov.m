clearAll
load reg_cov_map
load processed_data_sep27
load reg_cov_perturbations

numScans = 50;
nPoses = size(poses,2);

%%
load reg_cov_real_scans
i = 1;
fprintf('Stats for real...\n');
t1 = tic();
wgl = getWiggliness(scans{i},poses(:,i),map,perturbations);
S = getPoseCovariance([wgl.pEst]);
fprintf('Computation took %.2fs.\n',toc(t1));
