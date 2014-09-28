function S = getPoseCovariance(poses)
% poses is 3 x num poses
nPoses = size(poses,2);
mu = mean(poses,2);
residuals = zeros(size(poses));
residuals(1:2,:) = bsxfun(@minus,poses(1:2,:),mu(1:2));
residuals(3,:) = thDiff(mu(3)*ones(1,nPoses),poses(3,:));
S = cov(residuals');
end

