%% initialize
clear all; clc; close all;
load sample_sensor_data

pb = playbackTool(tEncArray,encArray,tLaserArray,laserArray);
encL = pb.createEncListener();
lzrL = pb.createLaserListener();

%% test encoder listening
encLog = struct('left',{},'right',{});
rangeLog = struct('ranges',{});
tLog = [];
update_count = 0;
pb.play();
t1 = tic();
while ~pb.endedFlag
    encLog(update_count+1).left = encL.data.left;
    encLog(update_count+1).right = encL.data.right;
    rangeLog(update_count+1).ranges = lzrL.data.ranges;
    tLog(update_count+1) = toc(t1);
    update_count = update_count+1;
    pause(0.001);
end
pb.shutdown();

%% test pause and play
pb.play();
pause(1);
pb.pause();
pause(2);
pb.play();
pause(1);
pb.shutdown;
tLog = pb.tLocalLog;

%% plot stuff
plot(tLog,[encLog.left]); hold on;
