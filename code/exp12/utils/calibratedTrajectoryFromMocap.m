function [poses,t] = calibratedTrajectoryFromMocap(mocapStruct,tfCalibFile)
%CALIBRATEDTRAJECTORYFROMMOCAP Calibrated robot trajectory from mocap.
% 
% [poses,t] = CALIBRATEDTRAJECTORYFROMMOCAP(mocapStruct,tfCalibFile)
% 
% mocapStruct - parseMocapData output.
% tfCalibFile - File name of tf calibration.
% 
% poses       - [3,numPoses] array.
% t           - Timestamps.

t = [mocapStruct.frame.timeStamp];
load(tfCalibFile);
markerPoses = getPosesFromMarkers(mocapStruct.frame,robotMarkerY,robotMarkerO);
relMarkerPoses = getRelativePoses(markerPoses,markerPoses(:,1));
poses = relMarkerPoses;
% poses = transformRelPosesOnRigidBody(relMarkerPoses,TrobotMarker_robot);

end