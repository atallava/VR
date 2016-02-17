% parameters
% path localizer parameters
pathLocalizerParams.smallestSegmentLength = 1e-2;
pathLocalizerParams.largestSegmentLength = 200.0;

% path tracker parameters
pathTrackerParams.maxDistanceThreshold = 15.0;
pathTrackerParams.progressForDone = 0.8;
pathTrackerParams.lookaheadDist = 1.0;

% sim parameters
simParams.updatePeriod = 0.01;

%% load some path
% pathFname = '../data/straight_line_path.txt';
pathFname = '../data/path_1.txt';
desiredPath = loadPath(pathFname);

%% run tracker
vehicleState = [desiredPath.pts(1,:) 0];

[vehicleStateLog,tLog] = executeTracker(desiredPath,vehicleState,simParams,pathTrackerParams);

%% plot
hf = plotDesiredAndFollowedPaths(desiredPath,vehicleStateLog);