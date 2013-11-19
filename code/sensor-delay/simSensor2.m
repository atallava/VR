%simulate sensor in a simple 2d world

load environments.mat

delete(timerfindall);
num_returns = 4;
laser = sensor(env1,[0 0 0],num_returns,5,3);
fpose = 100; %frequency for pose updates in Hz
tstamps = zeros(1,100);
ranges = zeros(100,num_returns);
poses = zeros(100,3);
v = 1; %robot velocity
T = 5; %duration of run


pose_update_timer = timer;
pose_update_timer.BusyMode = 'queue';
pose_update_timer.ExecutionMode = 'fixedRate';
pose_update_timer.Period = 1/fpose;
t1 = tic; %need to be careful when to start t1. tradeoff of using timers? issue also of dealing with matlab execution queue delays
pose_update_timer.TimerFcn = @(~,~) laser.updatePose([v*toc(t1); 0; 0]);
start(pose_update_timer);
pause(1);

laser.startSensor();
pause(1);

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
        throw(er);
    end
    poses(id,:) = laser.getPose();
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
