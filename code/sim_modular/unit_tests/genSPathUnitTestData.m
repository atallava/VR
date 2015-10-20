function genSPathUnitTestData()
% Drive the robot in a straight line. Check final position.
rob = neato('sim');
rstate = robState(rob);
rob.togglePlot();
load data/s_path_motion_vars

startPose = [0; 0; pi/2];
numRuns = 10;

xyArray = zeros(2,numRuns);
for i = 1:numRuns
	rob.sim_robot.pose = startPose;
	rstate.reset(rob.sim_robot.pose);
	pause(0.5);
	tfl.resetTrajectory(csp);
	tfl.execute(rob,rstate);
	pause(0.5);
	rob.sendVelocity(0,0);
	pause(0.5);
	xyArray(:,i) = rob.sim_robot.pose(1:2);
end
xyMu = mean(xyArray,2);
xyStd(1) = std(xyArray(1,:));
xyStd(2) = std(xyArray(2,:));

save('data/s_path_unit_test_data','tfl','csp','startPose','xyMu','xyStd');
rob.shutdown();
close all;
clear rob;
end
