% run initProcessMocapDataScript

warning('off');

%% parse mocap data
inputStruct.pre = '';
inputStruct.source = 'mocap';
inputStruct.tag = tag;
inputStruct.date = dateStr;
inputStruct.index = index;
inputStruct.format = '.csv';

fname = buildDataFileName(inputStruct);
mocapStruct = parseMocapData(fname);
load mocap_ground_plane_transform
mocapStruct = transformMocapStruct(mocapStruct,T);

%% calibrated robot poses from mocap
[poseLog,tMocap] = calibratedTrajectoryFromMocap(mocapStruct,tfCalibFile);
pose0 = poseLog(:,1);

%% logged robot commands
inputStruct.source = robotName;
inputStruct.format = '.mat';
fname = buildDataFileName(inputStruct);
load(fname);
% encoder data
encLog = enc.log;
tEnc = enc.tArray-enc.tArray(1)+enc.tLocalArray(1)+enc.tOffset;
% laser data
lzrLog = lzr.log;
tLzr = lzr.tArray-lzr.tArray(1)+lzr.tLocalArray(1)+lzr.tOffset;
% commanded velocities already logged

%% align clocks
load mocap_clock_calibration_params
xMocap = poseLog(1,:);
tMotionStartMocap = calcMotionStartTime(xMocap,tMocap,windowSize,threshold);
load encoder_clock_calibration_params
xEnc = [encLog.left];
tMotionStartEnc = calcMotionStartTime(xEnc,tEnc,windowSize,threshold);
tPose = tMocap-tMotionStartMocap+(tMotionStartEnc-tEncDelay);

%% throw away initial bit of data, when mocap can be shaky
throwPeriod = 5; % in seconds
tThrow = tPose(1)+throwPeriod;

ids = tPose < tThrow;
tPose(ids) = [];
poseLog(:,ids) = [];

ids = tInputV < tThrow;
tInputV(ids) = [];
inputVlLog(ids) = []; inputVrLog(ids) = [];

ids = tEnc < tThrow;
tEnc(ids) = [];
encLog(ids) = [];

ids = tLzr < tThrow;
tLzr(ids) = [];
lzrLog(ids) = [];

% smooth poseLog
% this has to be done after snipping away initial shaky bit! fragile system
poseLog = smoothPoseLog(poseLog);
pose0 = poseLog(:,1);

%% save data
inputStruct.pre = 'data/';
inputStruct.source = 'gt';
inputStruct.format = '.mat';
fname = buildDataFileName(inputStruct);
save(fname,'poseLog','tPose','pose0','inputVrLog','inputVlLog','tInputV', ...
	'encLog','tEnc','lzrLog','tLzr');
warning('on');