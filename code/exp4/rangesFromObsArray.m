function ranges = rangesFromObsArray(obsArray,poseId,obsIds)
%rangesFromObsArray get ranges from observation array
% obsArray is a cell array of size num poses x num pixels

ranges = cell2mat(obsArray(poseId,:));
ranges = ranges(obsIds,:);
ranges = squeeze(ranges);

end

