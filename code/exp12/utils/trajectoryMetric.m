function d = trajectoryMetric(p1Array,t1Array,p2Array,t2Array)
%TRAJECTORYMETRIC Euclidean distance between waypoints.
% 
% d = TRAJECTORYMETRIC(p1Array,t1Array,p2Array,t2Array)
% 
% p1Array - [3,length(t1Array)] pose array.
% t1Array - Timestamps for p1Array.
% p2Array - [3,length(t2Array)] pose array.
% t2Array - Timestamps for p2Array.
% 
% d       - Scalar difference.

tMin = max(t1Array(1),t2Array(1));
tMax = min(t1Array(end),t2Array(end));
dt = t1Array(2:end)-t1Array(1:end-1);
tRes = median(dt);
tArray = tMin:tRes:tMax;
% Re-time both trajectories.
p1ArrayI = interpTrajectory(p1Array,t1Array,tArray);
p2ArrayI = interpTrajectory(p2Array,t2Array,tArray);
dp = p1ArrayI-p2ArrayI; dp = dp(1:2,:);
% only xy difference
d = dp.^2; d = sum(d,1);
d = sqrt(mean(d));
% d = pose2D.poseNorm(p1ArrayI,p2ArrayI);
% d = mean(d);
end