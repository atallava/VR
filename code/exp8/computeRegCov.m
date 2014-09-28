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
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',500));

residuals = [];
count = 1;
nPoses = size(poses,2);
for i = 1:nPoses
    nScans = size(scans{i},1);
    poseRef = poses(:,i);
%     [~,poseRef] = refiner.refine(scans{i}(1,:),poseRef);
    residualsTemp = [];
    for j = 1:nScans
        [~,pEst] = refiner.refine(scans{i}(j,:),poseRef);
%         residualsTemp(:,end+1) = poseRef-pEst;
%         residualsTemp(3,end) = thDiff(pEst(3),poseRef(3));
        residuals(:,count) = poseRef-pEst;
        residuals(3,count) = thDiff(pEst(3),poseRef(3));
        count = count+1;
    end
%     residualsTemp = bsxfun(@minus,residualsTemp,mean(residualsTemp,2));
%     residuals = [residuals residualsTemp];
end
bias = mean(residuals,2);
S = cov(residuals');
end