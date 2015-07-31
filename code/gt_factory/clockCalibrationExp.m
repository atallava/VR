% rob, rstate must exist in workspace
% matlab-end code to calibrate local and mocap clocks

v = 0.1; % in m/s.
duration = 3; % in s
clockLocal = tic();
enc = encHistory(rob,clockLocal);
tStartEvtLocal = toc(clockLocal);
while (toc(clockLocal) < duration)
	rob.sendVelocity(v,v);
	pause(0.01);
end
rob.sendVelocity(0,0);
tStopEvtLocal = toc(clockLocal);
enc.stopListening();

%%
fname = 'data_230515_milli_3';
save(fname,'enc','tStartEvtLocal','tStopEvtLocal');
