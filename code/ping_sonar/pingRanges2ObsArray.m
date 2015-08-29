function obsArray = pingRanges2ObsArray(rangesCell)
    nPoses = length(rangesCell);
    nObs = length(rangesCell{1});
    nBearings = 1;
    obsArray = cell(nPoses,nBearings);
    for i = 1:nPoses
        data = rangesCell{i};
        data = cellfun(@str2num,data,'uniformoutput',0);
        throwIds = cellfun(@length,data);
        throwIds = throwIds ~= 1;
        data(throwIds) = [];
        data = cell2mat(data);
        data = round(data/(2*29)); % convert seconds to cm
        obsArray{i,1} = data;
    end
end