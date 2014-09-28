clearAll
load reg_cov_map
load('processed_data_sep27','poses')
load reg_cov_perturbations

numScans = 50;
nPoses = size(poses,2);
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));

%% Compute covariance
load reg_cov_real_scans
S = cell(1,nPoses);
Q = zeros(3);
t1 = tic();
for i = 1:1%nPoses
    [bias{i},S{i}] = computeRegCov(poses(:,i),{scans{i}},map);
    if norm(S{i}) > norm(Q)
        Q = S{i};
    end
end
fprintf('Computation took %.2fs.\n',toc(t1));


