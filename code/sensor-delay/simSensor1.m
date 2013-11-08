%simulate a 1d range sensor as it moves towards a point at constant velocity
%simulate using simple arrays
%time in s, distance in m/s

%frequency of sensing in Hz
fs = 10; 
v = 1; %speed of sensor
target = 10; %target position
pose = 0; %starting pose of sensor
T = 5; %total time of movement
ts = 0:1/fs:T; %sensor timestamps
range_s = 10-v*ts; %range instantaneously, 'at sensor'

tdelay = 0.2; %communication delay between query and sensor. equal both ways
fq = 30; %frequency of query in Hz
toff = 0.1; %time the query loop is offset to the sensing, assuming sensing...
%...starts at 0s
tq = toff:1/fq:T; %query timestamps
teff = tq+tdelay; %effective time when query reaches sensor
range_q = 10-v*getNearestTimes(ts,teff);
tfinal = teff+tdelay; %times when measurements finally arrive

h1 = figure;
scatter(ts,range_s,5,'b');
ha1 = gca;
title(ha1,'range at sensor stamps');
h2 = figure(2);
scatter(tq,range_q,5,'b');
ha2 = gca;
title(ha1,'range at sensor stamps');
figure;
scatter(tfinal,range_q,5,'b'); 
ha3 = gca;
title(ha3,'range at final arrival stamps');