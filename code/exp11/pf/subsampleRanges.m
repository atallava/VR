function [ranges,bearings] = subsampleRanges(ranges,bearings,skip)
    %SUBSAMPLERANGES
    %
    % [ranges,bearings] = SUBSAMPLERANGES(ranges,bearings,skip)
    %
    % ranges   - [1,B].
    % bearings - [1,B].
    % skip     - Scalar, optional.
    %
    % ranges   - Subsampled.
    % bearings - Subsampled.
    
    if nargin < 3
        skip = 5;
    end
    ids = 1:skip:length(ranges);
    ranges = ranges(ids);
    bearings = bearings(ids);
end