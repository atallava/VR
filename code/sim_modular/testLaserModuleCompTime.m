rob = neato2('sim'); 
rob.togglePlot();
load('../examples/nsh1_corridor.mat','map');
rob.sim_robot.pose = [1; 1; 0];
rob.setMap(map);
pause(0.5);
rob.startLaser();
someClock = tic();
while toc(someClock) < 60
	pause(0.01);
end

rob.stopLaser();
rob.shutdown();
tCompStruct = rob.sim_robot.getCompTime();
tCompStruct.laserModule

%%
clear rob