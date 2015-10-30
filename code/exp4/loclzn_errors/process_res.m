load loclzn_error_results
load processed_data_sep13

%%
nPoses = size(poses,2);
mus = zeros(3,nPoses);
covs = cell(1,nPoses);
for i = 1:nPoses
    mus(:,i) = mean(poseEstCell{i},2);
    covs{i} = cov(poseEstCell{i}');
end