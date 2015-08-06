function processMocapData(robotName,tag,dateStr,indices,tfCalibFile)
%PROCESSMOCAPDATA Processes mocap data using transform calibration to
% generate timestamped state estimates.
% 
% PROCESSMOCAPDATA(robotName,tag,dateStr,indices,tfCalibFile)
% 
% robotName   - 
% tag         - 
% dateStr     - 
% indices     - 
% tfCalibFile - 

for i = 1:length(indices)
	index = indices(i);
	% parse mocap data
	fname = buildDataFileName('mocap',tag,dateStr,index,'.csv');
	mocapStruct = parseMocapData(fname);
	load mocap_ground_plane_transform
	mocapStruct = transformMocapStruct(mocapStruct,T);
	
	% calibrated robot poses from mocap
	[robotMocapPoses,tMocap] = calibratedTrajectoryFromMocap(mocapStruct,tfCalibFile);
	
	% logged robot commands
	fname = buildDataFileName(robotName,tag,dateStr,index);
	load(fname);
	% encoder data
	encLog = enc.log;
	tEnc = enc.tArray-enc.tArray(1)+enc.tLocalArray(1)+enc.tLocalRelative;
	% laser data
	lzrLog = lzr.log;
	tLzr = lzr.tArray-lzr.tArray(1)+lzr.tLocalArray(1)+lzr.tLocalRelative;
	% commanded velocities
	inputVlLog = vlArray;
	inputVrLog = vrArray;
	tInputV = inputTArray+tInputOffset;
	
	% align clocks
	load mocap_clock_calibration_params
	xMocap = robotMocapPoses(1,:);
	tMotionStartMocap = calcMotionStartTime(xMocap,tMocap,windowSize,threshold);
	load encoder_clock_calibration_params
	xEnc = [encLog.left];
	tMotionStartEnc = calcMotionStartTime(xEnc,tEnc,windowSize,threshold);
	tMocap = tMocap-tMotionStartMocap+(tMotionStartEnc-tEncDelay);
	
	% save data
	fname = buildDataFileName('real',tag,dateStr,index);
	fname = ['data/processed_' fname];
	save(fname,'robotMocapPoses','tMocap','inputVrLog','inputVlLog','tInputV', ...
		'encLog','tEnc','lzrLog','tLzr');
end
end