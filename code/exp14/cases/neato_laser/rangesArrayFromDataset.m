function rangesArray = rangesArrayFromDataset(Y)
    %RANGESARRAYFROMDATASET
    %
    % rangesArray = RANGESARRAYFROMDATASET(Y)
    %
    % Y           - Struct array with fields ('ranges')
    %
    % rangesArray - [length(Y),nBearings] array.
    
    rangesArray = vertcat(Y.ranges);
end