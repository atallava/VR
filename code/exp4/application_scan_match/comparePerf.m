% Marginalize difference in performance over poses and patterns to a single
% measure (the average) for the mean and variance in pose error between
% real and all simulated data.

nSims = 4;
[poseErrMuDiffMarginalized,poseErrSDiffMarginalized] = deal(zeros(1,nSims));

for i = 1:nSims
    [muDiff,sDiff] = getDiffBetweenRealAndSim(i+1);
    poseErrMuDiffMarginalized(i) = mean(muDiff(:));
    poseErrSDiffMarginalized(i) = mean(sDiff(:));
end