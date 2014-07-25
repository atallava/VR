for i = 1:5
    temp = loadScoresByPose(i);
    meanScores(:,i) = [temp.scoresByPose.mu];
    stdScores(:,i) =  [temp.scoresByPose.s];
    choiceNames{i} = choiceString(i);
    choiceNames{i} = strrep(choiceNames{i},'_','\_');
end
[meanScoreDiff,stdScoreDiff] = deal(zeros(1,4));
for i = 1:4
    meanScoreDiff(i) = mean(abs(meanScores(:,1)-meanScores(:,i+1)));
    stdScoreDiff(i) = mean(abs(stdScores(:,1)-stdScores(:,i+1)));
end

%% plot stuff

figure; hold on;
nPoses = size(meanScores,1);
bar(1:nPoses,meanScores);
legend(choiceNames); title('Mean of score at different poses');
xlabel('pose'); ylabel('precision');
figure;
bar(1:nPoses,stdScores);
legend(choiceNames); title('Variance of score at different poses');
xlabel('pose'); ylabel('precision');