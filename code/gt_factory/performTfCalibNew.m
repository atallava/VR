% calibrate robot marker coordinates to robot coordinates
load('optiL_map','map'); % optiL map

%% pose from sensor registration
robotName = 'peta';
tag = 'tfcalib';
dateStr = '150524';
index = '1';
fname = buildDataFileName(robotName,tag,dateStr,index);
load(fname);

poseRobot = mean(poses,2);
Trobot_optiL = pose2D.poseToTransform(poseRobot); % in the realm of 2d transforms

%% parse mocap data
load mocap_ground_plane_transform
fname = buildDataFileName('mocap',tag,dateStr,index,'.csv');
mocapStruct = parseMocapData(fname);
% set floor plane to xy
mocapStruct = transformMocapStruct(mocapStruct,T);

%% optiL pose
% assuming that marker names are fixed through capture
% manual
optiLMarkerO = 'Marker-2'; % origin
optiLMarkerX = 'Marker-5'; % on x-axis
optiLMarkerY = 'Marker-3'; % on y-axis
optiLPose = getPosesFromMarkers(mocapStruct.frame(1),optiLMarkerO,optiLMarkerX);
ToptiL_world = pose2D.poseToTransform(optiLPose);

%% robot marker pose and final transform
% manual
robotMarkerO = 'Rigid Body 2-Marker 1';
robotMarkerX = 'Rigid Body 2-Marker 3';
robotRigidBodyId = 2;
poseRobotMarker = getPosesFromMarkers(mocapStruct.frame(1),robotMarkerO,robotMarkerX);
TrobotMarker_world = pose2D.poseToTransform(poseRobotMarker);
TrobotMarker_optiL = ToptiL_world\TrobotMarker_world;
TrobotMarker_robot = Trobot_optiL\TrobotMarker_optiL;
fname = ['tfcalib_' dateStr];
save(fname,'TrobotMarker_robot','robotMarkerO','robotMarkerX','robotRigidBodyId');
