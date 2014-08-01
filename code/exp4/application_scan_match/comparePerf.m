% Marginalize difference in performance over poses and patterns to a single
% measure (the average) for the mean and variance in pose error between
% real and all simulated data.

nSims = 4;
[poseErrMuDiffMgl,poseErrSDiffMgl] = deal(zeros(1,nSims));
algo = 'pcl';

for i = 1:nSims
    [muDiff,sDiff] = getDiffBetweenRealAndSim(i+1,algo);
    muDiff = abs(muDiff); sDiff = abs(sDiff);
    muPatternMgl(i,:) = mean(muDiff,1); sPatternMgl(i,:) = mean(sDiff,1);
    muPoseMgl(i,:) = mean(muDiff,2); sPoseMgl(i,:) = mean(sDiff,2);
    poseErrMuDiffMgl(i) = mean(muDiff(:));
    poseErrSDiffMgl(i) = mean(sDiff(:));

end

%% collapse everything and get a measure scaled by (collapsed) variance of real data
[mR,sR] = getPoseErrorData(1,algo);
mR = mean(mR(:));
sR = cStd(sR(:),10);
mDiff = zeros(1,4);
for i = 2:5
    [m,~] = getPoseErrorData(i,algo);
    mDiff(i-1) = (mR-mean(m(:)))/sR;
end