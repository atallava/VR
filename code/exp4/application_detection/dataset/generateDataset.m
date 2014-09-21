load samples
budget = 50;
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
    [~,id] = min(scores);
    id = datasample(id,1);
    confList(count) = sampleVec(id);
    aggregateMask = aggregateMask | sampleVec(id).mask;
    count = count+1;
    sampleVec(id) = [];
end
save('dataset','confList');
