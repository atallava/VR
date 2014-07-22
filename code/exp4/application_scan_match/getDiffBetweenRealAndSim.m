function [muDiff,sDiff] = getDiffBetweenRealAndSim(choice)
%GETDIFFBETWEENREALANDSIM Difference in poseError between real and
% simulated data.
% 
% res = GETDIFFBETWEENREALANDSIM(choice)
% 
% choice - Integer choice valid for loadStatsByPose.
% 
% res    - Array of size nPoses x nPatterns

[muReal,sReal] = getPoseErrorData(1);
[muSim,sSim] = getPoseErrorData(choice);
muDiff = muReal-muSim;
sDiff = sReal-sSim;

end

