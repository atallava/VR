function runPfExperiments(pfInputStructs,nTrials)
    %RUNPFEXPERIMENTS
    %
    % RUNPFEXPERIMENTS(pfInputStructs,nTrials)
    %
    % pfInputStructs - Cell array of structs.
    % nTrials        - Scalar.

    nExperiments = length(pfInputStructs);
    for i = 1:nExperiments
        fprintf('Experiment %d...\n',i);
        for j = 1:nTrials
            pfInputStruct = pfInputStructs{i};
            fprintf('Trial %d...\n',j);
            pfInputStruct.fnameRes = sprintf('%s_trial_%d',pfInputStruct.fnameRes,j);
            runParticleFilter(pfInputStruct);
        end
        fprintf('\n');
    end
end