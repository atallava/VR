clearAll
load processed_data_milli_160215
inputStruct.laser = laserClass(struct());
bsim = baselineSimulator(inputStruct);

%% sim obsArray
nObs = 200;
rangesCell = cell(1,size(poses,2));
for i = 1:size(poses,2)
    ranges = zeros(nObs,robotModel.laser.nPixels);
    for j = 1:nObs
        [r,~] = map.raycastNoisy(poses(:,i),robotModel.laser.maxRange,robotModel.laser.bearings);
        ranges(j,:) = r;
    end
    rangesCell{i} = ranges;
end

obsArray = cell(size(poses,2),robotModel.laser.nPixels);
for i = 1:size(poses,2)
	for j = 1:robotModel.laser.nPixels
		obsArray{i,j} = rangesCell{i}(:,j);
	end
end
trainPoseIds = [1:40];
testPoseIds = [41:50];

%% save data
save('processed_data_bsim_160215','obsArray','poses','trainPoseIds','testPoseIds');
