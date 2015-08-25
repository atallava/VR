function obsArray = subsampleObsArray(obsArray,frac)
    %SUBSAMPLEOBSARRAY
    %
    % obsArray = SUBSAMPLEOBSARRAY(obsArray,frac)
    %
    % obsArray - Cell of size [nPoses,nBearings]
    % frac     - Fraction of obsArray{i,j} to retain.
    %
    % obsArray -
    
    for i = 1:size(obsArray,1)
        for j = 1:size(obsArray,2)
            vec = obsArray{i,j};
            nKeep = ceil(frac*length(vec));
            obsArray{i,j} = randsample(vec,nKeep);
        end
    end
end