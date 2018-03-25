load sample_trajectories
load b100_padded_corridor
numTrajectories = 20;

%% Sim
load sim_sep6_1
rsim.setMap(map);
sensorData = struct('scanArray',{},'tArray',{});
t1 = tic();
for i = 1:numTrajectories
    [scanPoseArray,tArray] = scanPosesFromSampleTrajectory(sampleTrajectories(i).poseArray,sampleTrajectories(i).tArray);
    scanArray = cell(1,size(scanPoseArray,2));
    for j = 1:size(scanPoseArray,2)
		laserPose = robotModel.laser.refPoseToLaserPose(scanPoseArray(:,j));
        scanArray{j} = rsim.simulate(laserPose);
    end
    sensorData(end+1).scanArray = scanArray;
    sensorData(end).tArray = tArray;
end
fprintf('%.2fs\n',toc(t1));
save('sim_sensor_data','sensorData');

%% Baseline
load sim_baseline
rsim.setMap(map);
sensorData = struct('scanArray',{},'tArray',{});
t1 = tic();
for i = numTrajectories+1:2*numTrajectories
    [scanPoseArray,tArray] = scanPosesFromSampleTrajectory(sampleTrajectories(i).poseArray,sampleTrajectories(i).tArray);
    scanArray = cell(1,size(scanPoseArray,2));
    for j = 1:size(scanPoseArray,2)
		laserPose = robotModel.laser.refPoseToLaserPose(scanPoseArray(:,j));
        scanArray{j} = rsim.simulate(laserPose);
    end
    sensorData(end+1).scanArray = scanArray;
    sensorData(end).tArray = tArray;
end
fprintf('%.2fs\n',toc(t1));
save('baseline_sensor_data','sensorData');