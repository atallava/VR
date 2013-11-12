%simulate sensor in a simple 2d world...
%using update type 1

%create environment
wall1 = lineObject; wall2 = lineObject;
wall1.lines = [-20 6; 20 2]; wall2.lines = [-20 -6; 20 -2];
wall1.color = [1 0 0]; wall2.color = [1 0 0];
figure(1);
env = lineMap([wall1 wall2], 1);
hold on
scatter(0,0,50,'b+');
title(gca,'environment');
xlabel('x'); ylabel('y');

delete(timerfindall);
num_returns = 10;
laser = sensor(env,[0 0 0],num_returns,5);
fpose = 50; %frequency for pose updates in Hz
tstamps = zeros(1,100);
ranges = zeros(100,num_returns);
poses = zeros(100,3);
v = 1; %robot velocity
T = 5; %duration of run

laser.startSensor(2);
pause(0.1);

pose_update_timer = timer;
pose_update_timer.BusyMode = 'queue';
pose_update_timer.ExecutionMode = 'fixedRate';
pose_update_timer.Period = 1/fpose;
t1 = tic; %need to be careful when to start t1. tradeoff of using timers? issue also of dealing with matlab execution queue delays
pose_update_timer.TimerFcn = @(~,~) laser.updatePose([v*toc(t1) 0 0]);
start(pose_update_timer);

fq = 3; %query rate in Hz
id = 1;
toff = toc(t1);
t2 = tic;
while true
    t3 = toc(t2);
    tstamps(id) = toff + t3;
    try
        ranges(id,:) = laser.getRange();
    catch er
        whos
    end
    poses(id,:) = [v*toc(t1) 0 0];
    id = id + 1;
    if(t3 >= T)
        break;
    end    
    pause(1/fq);
end

stop(pose_update_timer);
laser.stopSensor();

%cleanup 
ids = find(tstamps);
tstamps = tstamps(ids); ranges = ranges(ids,:); poses = poses(ids,:);
%{
scatter(tstamps,ranges,5,'b');
ha = gca;
title(ha,'range measurement (m) vs time (s)');
%}