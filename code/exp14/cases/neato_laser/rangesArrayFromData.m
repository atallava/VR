function rangesArray = rangesArrayFromData(Y)
    %RANGESARRAYFROMDATA
    %
    % rangesArray = RANGESARRAYFROMDATA(Y)
    %
    % Y           - Struct array with fields ('ranges')
    %
    % rangesArray - [length(Y),nBearings] array.

    nBearings = length(Y(1).ranges);
    rangesArray = [Y.ranges];
    rangesArray = reshape(rangesArray,nBearings,length(Y))';
end