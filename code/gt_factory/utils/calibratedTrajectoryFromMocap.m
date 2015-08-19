function [poses,t] = calibratedTrajectoryFromMocap(mocapStruct,tfCalibFile)
%CALIBRATEDTRAJECTORYFROMMOCAP Calibrated robot trajectory from mocap.
% 
% [poses,t] = CALIBRATEDTRAJECTORYFROMMOCAP(mocapStruct,tfCalibFile)
% 
% mocapStruct - parseMocapData output. Ground plane has to be xy.
% tfCalibFile - File name of tf calibration.
% 
% poses       - [3,numPoses] array.
% t           - Timestamps.

t = [mocapStruct.frame.timeStamp];
load(tfCalibFile);
% robotMarkerO = 'Marker-4';
% robotMarkerX = 'Marker-2';
robotMarkerO = 'Rigid Body 1-Marker 3';
robotMarkerX = 'Rigid Body 1-Marker 2';
[poses,stats] = getPosesFromMarkers(mocapStruct.frame,robotMarkerO,robotMarkerX);
poses = getRobotPosesFromMarkerPoses(poses,TrobotMarker_robot);
vec = find(stats.framesMissingOrigin); id = vec(end)+1;
poses(1:2,stats.framesMissingOrigin) = repmat(poses(1:2,id),1,sum(stats.framesMissingOrigin));
end