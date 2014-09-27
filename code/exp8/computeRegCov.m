function [bias,S] = computeRegCov(poses,scans,map)
%COMPUTEREGCOV Compute covariance from registration.
% 
% [bias,S] = COMPUTEREGCOV(poses,scans,map)
% 
% poses - Robot poses. Array size 3 x nPoses.
% scans - Cell of scans at each pose.
% map   - lineMap object.
% 
% bias  - Bias of residuals.
% S     - Covariance of residuals.

localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',300));

count = 1;
nPoses = size(poses,2);
for i = 1:nPoses
    nScans = size(scans{i},1);
    for j = 1:nScans
        [~,pEst] = refiner.refine(scans{i}(j,:),poses(:,i));
        residuals(:,count) = poses(:,i)-pEst;
        residuals(3,count) = thDiff(pEst(3),poses(3,i));
        count = count+1;
    end
end
bias = mean(residuals,2);
S = cov(residuals');
end