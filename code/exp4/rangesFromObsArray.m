function ranges = rangesFromObsArray(obsArray,poseId,obsId)
%RANGESFROMOBSARRAY 
% 
% ranges = RANGESFROMOBSARRAY(obsArray,poseId,obsId)
% 
% obsArray - nPoses x nPixels cell array.

ranges = cell2mat(obsArray(poseId,:));
if nargin < 3
    obsId = randperm(size(ranges,1),1);
end
ranges = ranges(obsId,:);
ranges = squeeze(ranges);

end

