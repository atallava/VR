%% initialize
clear all; clc; close all;
load sample_sensor_data_2

rob = playbackTool(tEncArray,encArray,tLaserArray,laserArray);
rob.play();
lzr = laserHistory(rob);
lzr.togglePlot();
