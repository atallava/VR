load eval_local_match
thresh = 0.02;
pairs = [];
nTrain = [];
nClose = [];
for i = 1:size(predMuArray,1)
    pose = dp.poses(:,dp.testPoseIds(i));
    [r,~] = map.raycast(pose,dp.laser.maxRange,dp.laser.bearings);
    for j = 1:size(predMuArray,2)
        if abs(predMuArray(i,j)-r(j)) > thresh
            pairs(end+1,:) = [i j];
            px = muPxRegBundle.regressorArray{j};
            nTrain(end+1) = length(px.XTrain);
            nClose(end+1) = sum(toleranceCheck(px.XTrain,r(j),0.05));
        end
    end
end

% conclusion: errors upto