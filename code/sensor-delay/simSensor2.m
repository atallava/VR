delete(timerfindall);
sim = sensor(10,0);
fpose = 40; %time for pose updates
tstamps = zeros(1,100);
ranges = zeros(1,100);
v = 1; %robot velocity
T = 5; %duration of run

sim.startSensor();
pause(0.1);

pose_update_timer = timer;
pose_update_timer.BusyMode = 'queue';
pose_update_timer.ExecutionMode = 'fixedRate';
pose_update_timer.Period = 1/fpose;
t1 = tic; %need to be careful when to start t1. tradeoff of using timers? issue also of dealing with matlab execution queue delays
pose_update_timer.TimerFcn = @(~,~) sim.updatePose(v*toc(t1));
start(pose_update_timer);

fq = 20; %query rate in Hz
id = 1;
toff = toc(t1);
t2 = tic;
while true
    t3 = toc(t2);
    tstamps(id) = toff + t3;
    ranges(id) = sim.getRange();
    id = id + 1;
    if(t3 >= T)
        break;
    end    
    pause(1/fq);
end

stop(pose_update_timer);

%cleanup 
ids = find(tstamps);
tstamps = tstamps(ids); ranges = ranges(ids);
scatter(tstamps,ranges,5,'b');
ha = gca;
title(ha,'range measurement (m) vs time (s)');

