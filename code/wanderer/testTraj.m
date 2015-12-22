%% initialize
if ~exist('rob','var')
    error('ROB MUST EXIST IN WORKSPACE');
end
if ~exist('map','var')
    error('MAP MUST EXIST IN WORKSPACE');
end
if ~exist('rstate','var')
    error('RSTATE MUST EXIST IN WORKSPACE');
end

% initialize objects
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser,'rob',rob,'rstate',rstate)); 
vizerOD = vizRangesOnMap(struct('map',map,'laser',robotModel.laser)); % vizer 'On Demand'
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));
ctrlSw = swingController(struct('kp',0.1,'ki',0.0));
ctrlSt = controllerClass(struct('gainV',0.1,'gainW',0.05));

encLog = encHistory(rob);
lzrLog = laserHistory(rob);
startLog = []; goalLog = []; goalEncLog = []; goalTLog = []; % start, commanded goal, goal reported by encoders and true goal logs
tLog = []; % time (in encoder frame) after reaching a goal pose
refLog = struct('stats',{});
count = 1;
play = 1;

%% test trajectory following
while play
    % get a goal
    goal = input('Input next goal position: ');
    if isrow(goal)
        goal = goal';
    end
    
    % create trajectory
    [phi,dist] = swingStraight.getPhiAndDist(start,goal);
    trajSw = swingTraj(start,phi);
    trajSt = straightTraj(trajSw.goal,dist);
    
    fprintf('Executing trajectory...\n');
    % execute trajectory
    if ~exist('trajFlrSw','var')
        trajFlrSw = trajectoryFollower(struct('trajectory',trajSw,'controller',ctrlSw));
    else
        trajFlrSw.resetTrajectory(trajSw);
    end
    trajFlrSw.execute(rob,rstate);
    pause(1);
    if ~exist('trajFlrSt','var')
        trajFlrSt = trajectoryFollower(struct('trajectory',trajSt,'controller',ctrlSt));
    else
        trajFlrSt.resetTrajectory(trajSt);
    end
    trajFlrSt.execute(rob,rstate);
    pause(1);
    
    tLog(count) = encLog.tArray(end);
    % refine pose
    happy = false;
    while ~happy
        numIterations = input('Set num iterations: ');
        refiner.setNumIterations(numIterations);
        ranges = rob.laser.data.ranges;
        [refinerStats,pose] = refiner.refine(ranges,rstate.pose);
        vizerOD.viz(ranges,pose);
        happy = input('Happy? (1/0): ');
    end
    
    % log data
    startLog(:,count) = start;
    goalLog(:,count) = goal;
    goalEncLog(:,count) = rstate.pose;
    goalTLog(:,count) = pose;
    refinerStats.numIterations = numIterations;
    refLog(count).stats = refinerStats;
    rstate.reset(pose);
    start = rstate.pose;
    count = count+1;
    play = input('Continue? (1/0): ');
end

%% save stuff
fname = sprintf('data_%s',datestr(now,'mmmdd')); fname = lower(fname);
save(fname,'startLog','goalLog','goalEncLog','goalTLog','refLog','encLog','lzrLog','tLog');


