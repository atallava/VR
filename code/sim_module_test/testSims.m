load motion_vars

%% executed trajectories under various simulator models
% 0: simple, 1: add delays, 2: add noise and delays
[imFlag,emFlag] = meshgrid(0:2,0:2);
imFlag = imFlag(:); emFlag = emFlag(:);
specifySimOptions;
p = cell(1,length(imFlag));
t = cell(1,length(imFlag));

for i = 7%1:length(imFlag)
	clear rob rstate
	fprintf('Round %d.\n',i);
	options.inputModule.addDelay = imFlag(i);
	options.inputModule.addNoise = imFlag(i) > 1;
	options.encodersModule.addDelay = emFlag(i);
	options.encodersModule.addNoise = emFlag(i) > 1;
	save('sim_options','options','-append');
	pause(1);
	rob = neato2('sim');
	rob.togglePlot();
	pause(1);
	rstate = robState(rob);
	pause(1);
	tfl.resetTrajectory(csp);
	pause(0.5);
	tfl.execute(rob,rstate);
	pause(0.5);
	rob.shutdown();
	p{i} = rstate.pose_history(:,1:rstate.motion_count-1);
	t{i} = rstate.t_history(1:rstate.motion_count-1);
end

%%
d = zeros(1,9);
for i = 1:9
	d(i) = trajectoryMetric(p{i},t{i},p{9},t{9});
end