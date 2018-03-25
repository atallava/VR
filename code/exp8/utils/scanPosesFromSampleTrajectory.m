function [scanPoseArray,scanTArray] = scanPosesFromSampleTrajectory(poseArray,tArray)
%SCANPOSESFROMSAMPLETRAJECTORY Undersample at laser frequency.
% 
% [scanPoseArray,scanTArray] = SCANPOSESFROMSAMPLETRAJECTORY(poseArray,tArray)
% 
% poseArray     - 
% tArray        - 
% 
% scanPoseArray - 
% scanTArray    - 

dt = 0.2;
if iscolumn(tArray)
   tArray = tArray';
end
scanTArray = rand*dt:dt:tArray(end);
scanPoseArray = zeros(3,length(scanTArray));

scanPoseArray(1,:) = interp1(tArray,poseArray(1,:),scanTArray);
scanPoseArray(2,:) = interp1(tArray,poseArray(2,:),scanTArray);
scanPoseArray(3,:) = interp1(tArray,poseArray(3,:),scanTArray);
end

