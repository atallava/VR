% Marginalize difference in performance over poses and patterns to a single
% measure (the average) for the mean and variance in pose error between
% real and all simulated data.

nSims = 4;
[poseErrMuDiffMgl,poseErrSDiffMgl] = deal(zeros(1,nSims));

for i = 1:nSims
    [muDiff,sDiff] = getDiffBetweenRealAndSim(i+1);
    muDiff = abs(muDiff); sDiff = abs(sDiff);
    muPatternMgl(i,:) = mean(muDiff,1); sPatternMgl(i,:) = mean(sDiff,1);
    muPoseMgl(i,:) = mean(muDiff,2); sPoseMgl(i,:) = mean(sDiff,2);
    poseErrMuDiffMgl(i) = mean(muDiff(:));
    poseErrSDiffMgl(i) = mean(sDiff(:));
end

