load nsh3_corridor
load motion_vars

%%
localizer = lineMapLocalizer(map.objects);
rstate = robState(rob,'robot',ssp.startPose);
vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser,'rob',rob,'rstate',rstate));
count = 1;

%% Position the robot 
rstate.reset(ssp.startPose);
clear enc lzr tfl
tfl = trajectoryFollower(struct('trajectory',ssp,'controller',ctrl));

%% Run
lzr = laserHistory(rob);
lzr.togglePlot();
enc = encHistory(rob);
pause(2);
tfl.execute(rob,rstate);
pause(2);
lzr.togglePlot();
lzr.stopListening();
enc.stopListening();
sensorData(count).tfl = tfl;
sensorData(count).enc = enc;
sensorData(count).lzr = lzr;
count = count+1;





