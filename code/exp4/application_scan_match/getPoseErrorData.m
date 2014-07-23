function [muArray,sArray] = getPoseErrorData(choice)
%GETPOSEERRORDATA Extract pose error data.
% 
% [muArray,sArray] = GETPOSEERRORDATA(choice)
% 
% choice  - Valid choice for loadStatsByPose.
% 
% muArray - nPoses x nPatterns array.
% sArray  - nPoses x nPatterns array.

data = loadStatsByPose(choice);
nPoses = length(data.statsByPose);
nPatterns = length(data.statsByPose(1).errorStats);
[muArray,sArray] = deal(zeros(nPoses,nPatterns));

for i = 1:nPoses
    for j = 1:nPatterns
        muArray(i,j) = data.statsByPose(i).errorStats(j).poseError.mu;
        sArray(i,j) = data.statsByPose(i).errorStats(j).poseError.s;
    end
end

end

