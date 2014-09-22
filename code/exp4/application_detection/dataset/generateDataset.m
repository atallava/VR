load samples
budget = 50;

%% according to range vector
laserPose = [1.87;1.97;0]; 
for i = 1:length(sampleVec)
    ranges{i} = sampleVec(i).map.raycast(laserPose,robotModel.laser.maxRange,robotModel.laser.bearings);
end

count = 1;
id = randperm(length(sampleVec),1);
confList(count) = sampleVec(id); 
sampleVec(id) = []; ranges(id) = [];
aggregateRanges(1,:) = confList(count).map.raycast(laserPose,robotModel.laser.maxRange,robotModel.laser.bearings);
count = count+1;

while count <= budget
length(confList);
scores = zeros(1,length(sampleVec));
    for i = 1:length(sampleVec)
        distances = pdist2(aggregateRanges,ranges{i});
        scores(i) = min(distances);
    end
    [minVal,id] = max(scores);
    confList(count) = sampleVec(id);
    aggregateRanges(count,:) = sampleVec(id).map.raycast(laserPose,robotModel.laser.maxRange,robotModel.laser.bearings);
    count = count+1;
    sampleVec(id) = []; ranges(id) = [];
end

%% save results
save('dataset_rangenorm','confList');
