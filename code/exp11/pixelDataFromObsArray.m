function data = pixelDataFromObsArray(obsArray,pixelId,poseIds)
%PIXELDATAFROMOBSARRAY Extract single pixel data.
% 
% data = PIXELDATAFROMOBSARRAY(obsArray,pixelId,poseIds)
% 
% obsArray - 
% pixelId  - 
% poseIds  - 
% 
% data     - 2d Array of size numPoses x numObs

if nargin < 3
    poseIds = 1:size(obsArray,1);
end

M = length(obsArray{1,1});
data = zeros(length(poseIds),M);

for i = 1:length(poseIds)
    vec = obsArray{poseIds(i),pixelId};
    if length(vec) > M
        vec(M+1:end) = [];
    elseif length(vec) < M
        M = length(vec);
        data(:,M+1:end) = [];
    end
    data(i,:) = vec;
end

end

