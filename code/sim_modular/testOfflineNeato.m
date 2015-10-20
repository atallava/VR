% create some input velocity logs to test offline neato with
rob = neato2('sim');
pause(0.5);

duration = 2;
v = 0.1;
inputVlLog = []; inputVrLog = []; tInputV = [];

localClock = tic();
while toc(localClock) < duration
	tInputV(end+1) = toc(localClock);
	inputVlLog(end+1) = v;
	inputVrLog(end+1) = v;
	rob.sendVelocity(v,v);
	pause(0.1);
end
rob.sendVelocity(0,0);

%%
rob.shutdown();
clear rob; close all;