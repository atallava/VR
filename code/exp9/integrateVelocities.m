function [finalPose,poseArray] = integrateVelocities(startPose,VArray,wArray,tArray)
%INTEGRATEVELOCITIES 
% 
% finalPose = INTEGRATEVELOCITIES(vArray,tArray)
% 
% startPose - Initial pose, array of length 3.
% VArray    - Linear velocities.
% wArray    - Angular velocities.
% tArray    - Timestamps.
% 
% finalPose - Final pose.

poseArray = zeros(3,length(tArray)+1);
poseArray(:,1) = startPose;
% assumes that startPose is at time 0.
for i = 1:length(tArray)
    if i == 1
        dt = tArray(i);
    else
        dt = tArray(i)-tArray(i-1);
    end
    V = VArray(i);
    w = wArray(i);
    th = poseArray(3,i)+w*dt/2;
    poseArray(1,i+1) = poseArray(1,i)+V*cos(th)*dt;
    poseArray(2,i+1) = poseArray(2,i)+V*sin(th)*dt;
    poseArray(3,i+1) = poseArray(3,i)+w*dt;
end
finalPose = poseArray(:,end);

end