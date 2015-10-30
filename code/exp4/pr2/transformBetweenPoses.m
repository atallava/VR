function T = transformBetweenPoses(poses1,poses2)
% transform that takes poses1 to poses2

alpha = poses2(3,:)-poses1(3,:); 
alpha = mod(alpha,2*pi); alpha = mean(alpha);
dx = poses2(1,:)-cos(alpha)*poses1(1,:)+sin(alpha)*poses1(2,:); dx = mean(dx);
dy = poses2(2,:)-sin(alpha)*poses1(1,:)-cos(alpha)*poses1(2,:); dy = mean(dy);
T = [cos(alpha) -sin(alpha) dx; ...
    sin(alpha) cos(alpha) dy; ...
    0 0 1];
end

