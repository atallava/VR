function [poseError,tComputation] = scanErrorStatistic(refPose,scans,dPose)
%SCANERRORSTATISTIC 
% 
% [poseError,tComputation] = SCANERRORSTATISTIC(refPose,scans)
% 
% scans        - Array of size num scans x num pixels.
% refPose      - Array of length 3.
% dPose        - Perturbations. Array of size num perturbations x 3
% 
% poseError    - Pose estimate error (poseNorm) wrt refPose, averaged over
%                perturbations and scans.
% tComputation - Average time to complete scan.



end

