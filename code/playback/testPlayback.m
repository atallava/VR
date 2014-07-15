%% initialize
clearAll;
%load sample_sensor_data_2
load playback_data_july3

rob = playbackTool(tEncArray,encArray,tLaserArray,laserArray);
rob.play();
lzr = laserHistory(rob);
lzr.togglePlot();
