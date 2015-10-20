% static encoder
[ivlPub1,ivlSub1,delays1] = getTimeIntervals('data_static_enc_comm_milli_310115');
[ivlPub2,ivlSub2,delays2] = getTimeIntervals('data_static_enc_comm_laser_on_milli_310115');

plotIntervals(ivlPub1,ivlPub2,'static robot enc comm laser off','static robot enc comm laser on');
suptitle('pub');
plotIntervals(ivlSub1,ivlSub2,'static robot enc comm laser off','static robot enc comm laser on');
suptitle('sub');
plotIntervals(delays1,delays2,'static robot enc comm laser off','static robot enc comm laser on');
suptitle('delays');

%% motion encoder
[ivlPub1,ivlSub1,delays1] = getTimeIntervals('data_motion_enc_comm_milli_310115');
[ivlPub2,ivlSub2,delays2] = getTimeIntervals('data_motion_enc_comm_laser_on_milli_310115');

plotIntervals(ivlPub1,ivlPub2,'motion robot enc comm laser off','motion robot enc comm laser on');
suptitle('pub');
plotIntervals(ivlSub1,ivlSub2,'motion robot enc comm laser off','motion robot enc comm laser on');
suptitle('sub');
plotIntervals(delays1,delays2,'motion robot enc comm laser off','motion robot enc comm laser on');
suptitle('delays');

%% laser
[ivlPub1,ivlSub1,delays1] = getTimeIntervals('data_static_laser_comm_milli_310115');
[ivlPub2,ivlSub2,delays2] = getTimeIntervals('data_motion_laser_comm_milli_310115');

plotIntervals(ivlPub1,ivlPub2,'static robot enc comm laser off','motion robot enc comm laser on');
suptitle('pub');
plotIntervals(ivlSub1,ivlSub2,'static robot enc comm laser off','motion robot enc comm laser on');
suptitle('sub');
plotIntervals(delays1,delays2,'static robot enc comm laser off','motion robot enc comm laser on');
suptitle('delays');
