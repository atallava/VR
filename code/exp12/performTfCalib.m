% calibrate robot marker coordinates to robot coordinates
load tfcalib_map % opti-L as map
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser)); 
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));

%% pose from sensor registration
fname = 'data_peta_tfcalib_150524_1';
load(fname);
% might be beneficial to do this online
poseIn = [0.4; 0.4; pi/2]; % manual
numScans = size(ranges,1);
poseOutArray = zeros(3,numScans);
for i = 1:numScans
	[~,poseOutArray(:,i)] = refiner.refine(ranges(i,:),poseIn);
end
poseRobot = mean(poseOutArray,2);
Trobot_world = pose2D.poseToTransform(poseRobot);

%% parse mocap data
load mocap_transform
fname = 'data_mocap_tfcalib_150524_1.csv';
mocapStruct = parseMocapData(fname);
% set floor plane to xy
mocapStruct = transformMocapStruct(mocapStruct,T);

%% transform mocap coordinates relative to opti-L
% assuming that marker names are fixed through capture
% manual
markerName1 = 'Marker-2'; % origin
markerName2 = 'Marker-5'; % on x-axis
markerName3 = 'Marker-3'; % on y-axis
optiLPose = getPosesFromMarkers(mocapStruct.frame(1),markerName1,markerName2);
ToptiL_world = pose2D.poseToTransform(optiLPose);
Tworld_optiL = inv(ToptiL_world);
T3 = [cos(th) -sin(th)  0 optiLPose(1); ...
	sin(th) cos(th)  0 optiLPose(2); ...
	0 0 1 0; ...
	0 0 0 1];
T3 = inv(T3);
mocapStruct = transformMocapStruct(mocapStruct,T3);

%% robot marker pose from mocap
% manual
robotMarkerO = 'Rigid Body 2-Marker 3';
robotMarkerX = 'Rigid Body 2-Marker 1';
robotMarkerY = 'Rigid Body 2-Marker 2';
robotRigidBodyId = 2;
poseRobotMarker = getPosesFromMarkers(mocapStruct.frame(1),robotMarkerO,robotMarkerX);
TrobotMarker_world = pose2D.poseToTransform(poseRobotMarker);
TrobotMarker_robot = Trobot_world\TrobotMarker_world;
save('tfcalib_results_150524','TrobotMarker_robot','robotMarkerO','robotMarkerX','robotMarkerY','robotRigidBodyId');
