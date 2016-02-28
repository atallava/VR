function [meanErr,stdErr] = calcAvgTrajError(fnames)
    %CALCAVGTRAJERROR
    %
    % [meanErr,stdErr] = CALCAVGTRAJERROR(fnames)
    %
    % fnames  - Cell array of file names.
    %
    % meanErr - Mean errors.
    % stdErr  - Std of errors.
    
    nTrials = length(fnames);
    errVec = zeros(1,nTrials);
    for i = 1:nTrials
        load(fnames{i});
        mleTraj = extractMleTraj(particlesLog,weightsLog);
        % every odd measurement is an observation
        ids = 2*(1:size(poseHistory,2))-1;
        mleTraj = mleTraj(:,ids);
        trajError = pose2D.poseNorm(poseHistory,mleTraj);
        errVec(i) = mean(trajError);
    end
    meanErr = mean(errVec);
    stdErr = std(errVec);
end