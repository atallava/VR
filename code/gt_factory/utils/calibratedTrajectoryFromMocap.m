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
robotMarkerO = 'Marker-3';
robotMarkerX = 'Marker-2';
poses = getPosesFromMarkers(mocapStruct.frame,robotMarkerO,robotMarkerX);
% poses = getRobotPosesFromMarkerPoses(poses,TrobotMarker_robot);
% poses = getRelativePoses(poses,poses(:,1));
% poses = transformRelPosesOnRigidBody(poses,TrobotMarker_robot);

end