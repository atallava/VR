function moveRob(rob, v, T)
% send rob velocities v for time T

t1 = tic;
while toc(t1) < T
    rob.sendVelocity(v.left, v.right);
    pause(0.001);
end
rob.sendVelocity(0, 0);
end
