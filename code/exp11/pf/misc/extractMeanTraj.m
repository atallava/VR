function traj = extractMeanTraj(particlesLog,weightsLog)
    nMeasurements = length(weightsLog);
    for i = 1:nMeasurements
        traj(:,i) = meanParticlePose(particlesLog{i},weightsLog{i});
    end
end