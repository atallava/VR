function traj = extractMleTraj(particlesLog,weightsLog)
    nMeasurements = length(weightsLog);
    traj = zeros(3,nMeasurements+1);
    for i = 1:nMeasurements
        [~,maxId] = max(weightsLog{i});
        traj(:,i) = particlesLog{i}(maxId).pose;
    end
    traj(:,end) = particlesLog{end}(maxId).pose;
end