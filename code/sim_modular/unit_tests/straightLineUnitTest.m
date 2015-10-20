function straightLineUnitTest(neatoSimClass)
% Drive the robot in a straight line. Check final position.
rob = neatoSimClass('sim');
rob.togglePlot();
load data/straight_line_unit_test_data.mat

rob.sim_robot.pose = startPose;
pause(1);
tClock = tic;
while toc(tClock) < duration
	rob.sendVelocity(v,v);
	pause(0.1);
end
rob.sendVelocity(0,0);
pause(0.01);
x = rob.sim_robot.pose(1);
flag = (xMu-5*xStd <= x) && (x <= xMu+5*xStd);
if flag
	fprintf('STRAIGHT LINE UNIT TEST PASSED.\n');
else
	error('STRAIGHT LINE UNIT TEST FAILED');
end

rob.shutdown();
close all;
clear rob;
end