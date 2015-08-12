% calibrate robot marker coordinates to robot coordinates
load('optiL_map','map'); % optiL map

%% pose from sensor registration
robotName = 'peta';
tag = 'tfcalib';
dateStr = '150804';
index = '1';
fname = buildDataFileName(robotName,tag,dateStr,index);
load(fname);

poseRobot = mean(poses,2);
Trobot_optiL = pose2D.poseToTransform(poseRobot); % in the realm of 2d transforms
Trobot_optiL(1:2,3) = Trobot_optiL(1:2,3)+optiL_map_marker_offset;

%% parse mocap data
load mocap_ground_plane_transform
fname = buildDataFileName('mocap',tag,dateStr,index,'.csv');
mocapStruct = parseMocapData(fname);
% set floor plane to xy
mocapStruct = transformMocapStruct(mocapStruct,T);

%% optiL pose
% assuming that marker names are fixed through capture
load(['marker_names_' dateStr]);
optiLPose = getPosesFromMarkers(mocapStruct.frame(1),optiLMarkerO,optiLMarkerX);
ToptiL_world = pose2D.poseToTransform(optiLPose);

%% robot marker pose and final transform
% manual
poseRobotMarker = getPosesFromMarkers(mocapStruct.frame(1),robotMarkerO,robotMarkerX);
TrobotMarker_world = pose2D.poseToTransform(poseRobotMarker);
TrobotMarker_optiL = ToptiL_world\TrobotMarker_world;
TrobotMarker_robot = Trobot_optiL\TrobotMarker_optiL;
fname = ['tfcalib_' dateStr];
save(fname,'TrobotMarker_robot','robotMarkerO','robotMarkerX','robotRigidBodyId');
