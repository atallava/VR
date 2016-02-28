function traj = extractMleTraj(particlesLog,weightsLog)
    %EXTRACTMLETRAJ
    %
    % traj = EXTRACTMLETRAJ(particlesLog,weightsLog)
    %
    % particlesLog - Cell array.
    % weightsLog   - Cell array. 
    %
    % traj         - [3,nPoses] array.

    nMeasurements = length(weightsLog);
    traj = zeros(3,nMeasurements);
    for i = 1:nMeasurements
        [~,maxId] = max(weightsLog{i});
        traj(:,i) = particlesLog{i}(maxId).pose;
    end
end