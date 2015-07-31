function poses = getPosesFromMarkers(frames,markerNameO,markerNameX)
%GETPOSESFROMMARKERS Get 2D pose of body described by markers in frames.
% Assumes z-axis points out of the ground.
% 
% poses = GETPOSESFROMMARKERS(frames,markerNameO,markerNameX)
% 
% frames      - Frames from mocap data struct.
% markerNameO - String, corresponds to origin marker.
% markerNameX - String, corresponds to x-axis marker.
% 
% poses       - [3,numFrames] array of [x,y,theta] data.

numFrames = length(frames);
poses = zeros(3,numFrames);
for j = 1:numFrames
	markerPts = zeros(2,3);
	frame = frames(j);
	for i = 1:length(frame.markerNames)
		if strcmp(frame.markerNames{i},markerNameO)
			markerPts(:,1) = frame.markerPosns(1:2,i);
		elseif strcmp(frame.markerNames{i},markerNameX)
			markerPts(:,2) = frame.markerPosns(1:2,i);
		else
			continue;
		end
	end
	vec = markerPts(:,2)-markerPts(:,1);
	vec = vec/norm(vec);
	th = atan2(vec(2),vec(1));
	poses(:,j) = [markerPts(1,1); markerPts(2,1); th];
end
end