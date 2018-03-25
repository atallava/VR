function [V,w] = velocityFromPoses(pose1,pose2,dt)
w = thDiff(pose1(3),pose2(3))/dt;
p2d1 = pose2D(pose1);
err = p2d1.T\[pose2(1); pose2(2); 1];
th = atan2(err(2),err(1));
V = norm(err(1:2))/dt;
if abs(th) > pi/2
    V = -V;
end
end
