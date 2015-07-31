function robotPoses = getRobotPosesFromMarkerPoses(markerPoses,TrobotMarker_robot)

numPoses = size(markerPoses,2);
robotPoses = zeros(size(markerPoses));

for i = 1:numPoses
	Tmarker_world = pose2D.poseToTransform(markerPoses(:,i));
	Trobot_world = Tmarker_world/TrobotMarker_robot;
	robotPoses(:,i) = pose2D.transformToPose(Trobot_world);
end

end