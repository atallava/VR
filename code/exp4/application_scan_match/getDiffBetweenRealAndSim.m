function [muDiff,sDiff] = getDiffBetweenRealAndSim(choice,algo)
%GETDIFFBETWEENREALANDSIM Difference in poseError between real and
% simulated data.
% 
% res = GETDIFFBETWEENREALANDSIM(choice)
% 
% choice - Integer choice valid for loadStatsByPose.
% algo   - String of algorithm name. 
% res    - Array of size nPoses x nPatterns

[muReal,sReal] = getPoseErrorData(1,algo);
[muSim,sSim] = getPoseErrorData(choice,algo);
muDiff = muReal-muSim;
sDiff = sReal-sSim;

end

