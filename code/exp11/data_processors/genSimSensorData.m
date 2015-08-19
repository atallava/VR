% generate simulated sensor readings
load ../exp4/data/processed_data_sep6.mat
load ../exp4/data/roomLineMap.mat

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

%%
save('data/processed_data_sep6_2.mat','obsArray','poses','testPoseIds','trainPoseIds');