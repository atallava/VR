% initialize
robotName = 'peta';
tag = 'traj';
dateStr = '150524';
index = '1';

%% parse mocap data
fname = buildDataFileName('mocap',tag,dateStr,index,'.csv');
mocapStruct = parseMocapData(fname);
load mocap_ground_plane_transform
mocapStruct = transformMocapStruct(mocapStruct,T);

%% calibrated robot poses from mocap
tfCalibFile = 'tfcalib_150524';
[poseLog,tMocap] = calibratedTrajectoryFromMocap(mocapStruct,tfCalibFile);

%% logged robot commands
fname = buildDataFileName(robotName,tag,dateStr,index);
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

%% save data
fname = buildDataFileName('gt',tag,dateStr,index);
save(fname,'robotMocapPoses','tPose','inputVrLog','inputVlLog','tInputV', ...
	'encLog','tEnc','lzrLog','tLzr');
