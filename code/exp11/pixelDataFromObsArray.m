function data = pixelDataFromObsArray(obsArray,pixelId,poseIds)
%PIXELDATAFROMOBSARRAY Extract single pixel data.
% 
% data = PIXELDATAFROMOBSARRAY(obsArray,pixelId,poseIds)
% 
% obsArray - 
% pixelId  - 
% poseIds  - 
% 
% data     - length(poseIds) cell array.

if nargin < 3
    poseIds = 1:size(obsArray,1);
end

data = cell(1,length(poseIds));

for i = 1:length(poseIds)
    vec = obsArray{poseIds(i),pixelId};
    % can process vec further
    vec(vec == 0) = []; % throw away zeros
    data{i} = vec;
end

end

