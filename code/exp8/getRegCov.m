clearAll
load reg_cov_map
load('processed_data_sep27','poses')
load reg_cov_perturbations

numScans = 50;
nPoses = size(poses,2);

%% Compute covariance
load reg_cov_real_scans
S = cell(1,nPoses);
fprintf('Stats for real...\n');
t1 = tic();
for i = 1
    wgl = getWiggliness(scans{i},poses(:,i),map,perturbations);
    S{i} = getPoseCovariance([wgl.pEst]);
end
fprintf('Computation took %.2fs.\n',toc(t1));


