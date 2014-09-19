function res = examineStd(choiceVec)
%EXAMINESTD Look at quantile stds for poseError various cases.
% 
% res = EXAMINESTD(choiceVec)
% 
% choiceVec - Vector with integers which are valid for loadStatsByPose.
% 
% res       - nPoses x length(choiceVec) array of stds.

nChoice = length(choiceVec);
temp = loadStatsByPose(1);
nPoses = length(temp);
nPatterns = length(temp.statsByPose(1).errorStats);
res = zeros(nPoses,nChoice);
percentileOfInterest = 0.9;

for i = 1:length(choiceVec)
    data = loadStatsByPose(choiceVec(i));
    for j = 1:nPoses
        vec = zeros(1,nPatterns);
        for k = 1:nPatterns
            vec(k) = data.statsByPose(j).errorStats(k).pointError.s;
        end
        res(j,i) = quantile(vec,percentileOfInterest);
    end
end

end

