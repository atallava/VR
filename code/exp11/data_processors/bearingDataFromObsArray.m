function data = bearingDataFromObsArray(obsArray,bearingId,poseIds)
%BEARINGDATAFROMOBSARRAY Extract single bearing data.
% 
% data = BEARINGDATAFROMOBSARRAY(obsArray,bearingId,poseIds)
% 
% obsArray - 
% bearingId  - 
% poseIds  - 
% 
% data     - length(poseIds) cell array.

if nargin < 3
    poseIds = 1:size(obsArray,1);
end

data = cell(1,length(poseIds));

for i = 1:length(poseIds)
    vec = obsArray{poseIds(i),bearingId};
    % can process vec further
    vec(vec == 0) = []; % throw away zeros
    data{i} = vec;
end

end

