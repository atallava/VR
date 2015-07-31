function T = getTransformsFromMarkers(frames,markerNameO,markerNameX)
%GETTRANSFORMSFROMMARKERS 
% 
% T = GETTRANSFORMSFROMMARKERS(mocapStruct,markerNameO,markerNameX)
% 
% frames      - Frames from mocapStruct.
% markerNameO - Origin marker.
% markerNameX - x-axis marker.
% 
% T           - Set of transforms.

poses = getPosesFromMarkers(frames,markerNameO,markerNameX);
T = pose2D.poseToTransform(poses);
end