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
pathFname = '../data/straight_line_path.txt';
desiredPath = loadPath(pathFname);
desiredPathSegments = pathToSegments(desiredPath,pathLocalizerParams);

%% run tracker
vehicleState.x = desiredPath(1).x;
vehicleState.y = desiredPath(1).y;
vehicleState.yaw = 0;

[vehicleStateLog,tLog] = executeTracker(desiredPathSegments,vehicleState,simParams,pathTrackerParams);

%% plot
hf = plotDesiredAndFollowedPaths(desiredPath,vehicleStateLog);