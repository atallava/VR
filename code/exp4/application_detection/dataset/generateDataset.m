load samples
budget = 50;

%% according to mask 
count = 1;
id = randperm(length(sampleVec),1);
confList(count) = sampleVec(id); 
sampleVec(id) = [];
aggregateMask = confList(count).mask;
count = count+1;
while count <= budget
    scores = zeros(1,length(sampleVec));
    for i = 1:length(sampleVec)
        scores(i) = sampleConfiguration.scoreMasks({aggregateMask,sampleVec(i).mask});
    end
    [minVal,id] = min(scores);
    confList(count) = sampleVec(id);
    aggregateMask = aggregateMask | sampleVec(id).mask;
    count = count+1;
    sampleVec(id) = [];
end

%% according to range vector
count = 1;
id = randperm(length(sampleVec),1);
confList(count) = sampleVec(id); 
sampleVec(id) = [];
laserPose = [1.835;1.935;0]; 
aggregateRanges(1,:) = confList(count).map.raycast(laserPose,robotModel.laser.maxRange,robotModel.laser.bearings);
count = count+1;
while count <= budget
scores = zeros(1,length(sampleVec));
    for i = 1:length(sampleVec)
        ranges = sampleVec(i).map.raycast(laserPose,robotModel.laser.maxRange,robotModel.laser.bearings);
        distances = pdist2(aggregateRanges,ranges);
        scores(i) = min(ranges);
    end
    [minVal,id] = max(scores);
    sum(scores == minVal)/length(scores)
    confList(count) = sampleVec(id);
    aggregateRanges(count,:) = sampleVec(id).map.raycast(laserPose,robotModel.laser.maxRange,robotModel.laser.bearings);
    count = count+1;
    sampleVec(id) = [];
end

%% save results
save('dataset','confList');
