clearAll
load processed_data_milli_160215
inputStruct.laser = laserClass(struct());
bsim = baselineSimulator(inputStruct);
nObs = 200;

%% train poses
load mock_map_train
bsim.map = map;
ranges = cell(1,size(poses,2));
for i = trainPoseIds
	fprintf('Pose id: %d\n',i);
	data = zeros(nObs,bsim.laser.nBearings);
	for j = 1:nObs
		data(j,:) = bsim.simulate(poses(:,i));
	end
	ranges{i} = data;
end
obsArray = cell(size(poses,2),bsim.laser.nBearings);

for i = trainPoseIds
	for j = 1:bsim.laser.nBearings
		obsArray{i,j} = ranges{i}(:,j);
	end
end

%% test poses
load mock_map_test
bsim.map = map;
for i = testPoseIds
	fprintf('Pose id: %d\n',i);
	data = zeros(nObs,bsim.laser.nBearings);
	for j = 1:nObs
		data(j,:) = bsim.simulate(poses(:,i));
	end
	ranges{i} = data;
end

for i = trainPoseIds
	for j = 1:bsim.laser.nBearings
		obsArray{i,j} = ranges{i}(:,j);
	end
end

%% save data
save('processed_data_bsim_160215','obsArray','poses','trainPoseIds','testPoseIds');
