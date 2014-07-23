function [muArray,sArray] = getPointErrorData(choice)
%GETPOINTERRORDATA Extract point error data.
% 
% [muArray,sArray] = GETPOINTERRORDATA(choice)
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
        muArray(i,j) = data.statsByPose(i).errorStats(j).pointError.mu;
        sArray(i,j) = data.statsByPose(i).errorStats(j).pointError.s;
    end
end

end