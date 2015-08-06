fname = 'sample_mocap_data_2.csv';
out = parseMocapData(fname);

%% plot rigid body positions
pts = [out.frames.p];
figure;
plot3(pts(1,:),pts(2,:),pts(3,:));
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');

%% compare marker posns and point cloud posns

pts = [out.rbody.markerPosns];
markerPts = cell(1,out.numMarkers);
for i = 1:out.numMarkers
	ids = i:out.numMarkers:((out.numFrames-1)*out.numMarkers+i);
	markerPts{i} = pts(:,ids);
	plot3(markerPts{i}(1,:),markerPts{i}(2,:),markerPts{i}(3,:),'g'); hold on;
end

pts = [out.rbody.pcPosns];
pcPts = cell(1,out.numMarkers);
for i = 1:out.numMarkers;
	ids = i:out.numMarkers:i+out.numFrames;
	pcPts{i} = pts(:,ids);
	plot3(pcPts{i}(1,:),pcPts{i}(2,:),pcPts{i}(3,:),'r'); hold on;
end

axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
