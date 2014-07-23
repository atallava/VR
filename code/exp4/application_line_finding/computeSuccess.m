clear all; clc
load processed_data_june6
load lineSetFixedLength
load('../mats/full_predictor_mar27_5','rsim');
load map1.mat

nPoses = length(obsArrayByPose);
nTrials = 10;
numLines = 2;
targetLen = 0.61;

%% score on real range data
plot_option = 1;
poseScore = zeros(1,nPoses);
%{
for i = 6%1:nPoses
    fprintf('pose %d\n',i);
    obsIds = randperm(size(obsArrayByPose{i},1),nTrials);
    score = 0;
    for j = obsIds
        ranges = obsArrayByPose{i}(j,:);
        ri = rangeImage(struct('ranges',ranges,'cleanup',1));
        %lines = findLinesHT(ri,numLines);
        [lines,~] = getLines(ri,targetLen);
        if isempty(lines)
            continue;
        end
        if plot_option
            hf = ri.plotXvsY([],5); title(sprintf('pose %d, obs %d',i,j));
            hold on;
            for k = 1:length(lines)
                plot([lines(k).p1(1) lines(k).p2(1)],[lines(k).p1(2) lines(k).p2(2)],'g','LineWidth',3);
            end
            for k = 1:length(lineSet{i})
                plot([lineSet{i}(k).p1(1) lineSet{i}(k).p2(1)],[lineSet{i}(k).p1(2) lineSet{i}(k).p2(2)],'-r','LineWidth',2);
            end
            waitforbuttonpress
            close(hf);
            fprintf('score: %f\n',scoreLineFinding(lineSet{i},lines));
        end
        score = score+scoreLineFinding(lineSet{i},lines);
    end
    poseScore(i) = score/nTrials;
end
%}
%% score on simulated data
plot_option = 1;
poseScore = zeros(1,nPoses);
robotPose = [0;0;0];
warning('off');
for i = 8%1:nPoses
    fprintf('pose %d\n',i);
    lObjArray = lines2LineObjects(lineSet{i});
    tempMap = lineMap([room.objects lObjArray]);
    rsim.setMap(tempMap);
    score = 0;
    for j = 1:nTrials
        ranges = rsim.simulate(robotPose);
        %ranges = tempMap.raycastNoisy(robotPose,5,deg2rad(0:359));
        ri = rangeImage(struct('ranges',ranges,'cleanup',1));
        %lines = findLinesHT(ri,numLines);
        [lines,~] = getLines(ri,targetLen);
        
        if plot_option
            hf = ri.plotXvsY([],5); title(sprintf('pose %d, obs %d',i,j));
            hold on;
            for k = 1:length(lineSet{i})
                plot([lineSet{i}(k).p1(1) lineSet{i}(k).p2(1)],[lineSet{i}(k).p1(2) lineSet{i}(k).p2(2)],'-r','LineWidth',2);
            end
            if ~isempty(lines)
                for k = 1:length(lines)
                    plot([lines(k).p1(1) lines(k).p2(1)],[lines(k).p1(2) lines(k).p2(2)],'g','LineWidth',3);
                end
            end
            waitforbuttonpress
            close(hf);
            fprintf('score: %f\n',scoreLineFinding(lineSet{i},lines));
        end
        
        if ~isempty(lines)
            score = score+scoreLineFinding(lineSet{i},lines);
        end
    end
    poseScore(i) = score/nTrials;
end
