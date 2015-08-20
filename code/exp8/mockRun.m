load motion_vars
load nsh3_corridor
rob.genMap(map.objects);
rob.sim_robot.pose = ssp.startPose;
rob.startLaser();
pause(1);
rstate = robState(rob,'robot',ssp.startPose);
lzr = laserHistory(rob);
enc = encHistory(rob);
pause(2);
tfl.execute(rob,rstate);
pause(2);
lzr.stopListening;
enc.stopListening;

rFilter = registrationFilter('baseline');
[scanArray,tArray] = laserHist2scanArray(lzr,tfl);
rFilter.filter(ssp.startPose,S0,scanArray,tArray,map);