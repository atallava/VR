function meanPose = meanParticlePose(particles,weights)
    poses = [particles.pose]; % [3,nPoses]
    weights = flipVecToRow(weights);
    weightedPoses = bsxfun(@times,poses,weights);
    meanPose = mean(weightedPoses,2);
end