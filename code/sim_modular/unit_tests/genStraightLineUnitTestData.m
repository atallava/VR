function genStraightLineUnitTestData()
% Drive the robot in a straight line. Check final position.
rob = neato('sim');
rob.togglePlot();

duration = 2;
v = 0.1;
startPose = [0; 0; 0];
numRuns = 15;

xArray = zeros(1,numRuns);
for i = 1:numRuns
	rob.sim_robot.pose = startPose;
	%i
	tClock = tic;
	while toc(tClock) < duration
		rob.sendVelocity(v,v);
		pause(0.001);
	end
	rob.sendVelocity(0,0);
	xArray(i) = rob.sim_robot.pose(1);
	pause(0.001);
end
xMu = mean(xArray);
xStd = std(xArray);

save('data/straight_line_unit_test_data','duration','v','startPose','xMu','xStd');
rob.shutdown();
close all;
clear rob;
end

