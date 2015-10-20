function sPathUnitTest(neatoSimClass)
% Drive the robot in a straight line. Check final position.
rob = neatoSimClass('sim');
rstate = robState(rob);
rob.togglePlot();
load data/s_path_unit_test_data.mat

rob.sim_robot.pose = startPose;
rstate.reset(rob.sim_robot.pose);
pause(0.5);
tfl.resetTrajectory(csp);
tfl.execute(rob,rstate);
pause(0.5);
rob.sendVelocity(0,0);
pause(0.5);
x = rob.sim_robot.pose(1);
y = rob.sim_robot.pose(2);

flag1 = (xyMu(1)-5*xyStd(1) <= x) && (x <= xyMu(1)+5*xyStd(1));
flag2 = (xyMu(2)-5*xyStd(2) <= y) && (y <= xyMu(2)+5*xyStd(2));
flag = flag1 && flag2;
if flag
	fprintf('S PATH UNIT TEST PASSED.\n');
else
	error('S PATH UNIT TEST FAILED');
end
rob.shutdown();
close all;
clear rob;
end