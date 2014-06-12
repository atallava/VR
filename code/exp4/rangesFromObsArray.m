function ranges = rangesFromObsArray(obsArray,poseId,obsId)
%rangesFromObsArray get ranges from observation array
% obsArray is a cell array of size num poses x num pixels

ranges = cell2mat(obsArray(poseId,:));
if nargin < 3
    obsId = randperm(size(ranges,1),1);
end
ranges = ranges(obsId,:);
ranges = squeeze(ranges);

end

