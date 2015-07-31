% extract mocap trajectory data
fname = 'data_mocap_traj_150524_1.csv';
mocapStruct = parseMocapData(fname);
load mocap_transform
mocapStruct = transformMocapStruct(mocapStruct,T);

%% 
load tfcalib_results_150524
markerPoses = getPosesFromMarkers(mocapStruct.frame,robotMarkerY,robotMarkerO); %YO
relMarkerPoses = getRelativePoses(markerPoses,markerPoses(:,1));
robotMocapPoses = transformRelPosesOnRigidBody(relMarkerPoses,TrobotMarker_robot);

%%
poses = robotMocapPoses;
ids = 1:200:size(poses,2);
figure; hold on; 
for i = ids
	quiver(poses(1,i),poses(2,i),0.1*cos(poses(3,i)),0.1*sin(poses(3,i)),'k');
end
axis equal
