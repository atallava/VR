function scoresByPose = testLineFinding(choice,plotOption)
% choice: {'real','baseline','sim','sim_pooled','sim_local_match'}
% plotOption: default 0

addpath(genpath('../'));
load lineSetFixedLength
load map1.mat
if nargin < 2
    plotOption = 0;
end
switch choice
    case 'real'
        load('processed_data_june6','obsArrayByPose');
    case 'baseline'
        % nothing to be done
    case 'sim'
        load('../mats/full_predictor_mar27_1','rsim');
    case 'sim_pooled'
        load('../mats/full_predictor_mar27_4','rsim');
    case 'sim_local_match'
        load('../mats/full_predictor_mar27_5','rsim');
    otherwise 
        error('INVALID CHOICE.')
end

nPoses = length(lineSet);
nTrials = 20;
targetLen = 0.61;

scoresByPose = struct('mu',{},'s',{});
robotPose = [0;0;0];

warning('off');
for i = 3%1:nPoses
    fprintf('pose %d\n',i);
    % Construct map with targets.
    lObjArray = lines2LineObjects(lineSet{i});
    tempMap = lineMap([room.objects lObjArray]);
    switch choice
        case {'real','baseline'}
            % nothing to be done
        otherwise
            rsim.setMap(tempMap);
    end
    scoreVec = zeros(1,nTrials);
    % Run multiple trials.
    for j = 1:nTrials
        switch choice
            case 'real'
                obsId = randperm(size(obsArrayByPose{i},1),1);
                ranges = obsArrayByPose{i}(obsId,:);
            case 'baseline'
                ranges = tempMap.raycastNoisy(robotPose,5,deg2rad(0:359));
            otherwise
                ranges = rsim.simulate(robotPose);
        end
        % Find lines.
        ri = rangeImage(struct('ranges',ranges,'cleanup',1));
        [lines,~] = getLines(ri,targetLen);
        
        % Plot stuff.
        if plotOption
            hf = ri.plotXvsY([],5); title(sprintf('pose %d, obs %d',i,j));
            hold on;
            if ~isempty(lines)
                for k = 1:length(lines)
                    plot([lines(k).p1(1) lines(k).p2(1)],[lines(k).p1(2) lines(k).p2(2)],'g','LineWidth',3);
                end
            end
            for k = 1:length(lineSet{i})
                plot([lineSet{i}(k).p1(1) lineSet{i}(k).p2(1)],[lineSet{i}(k).p1(2) lineSet{i}(k).p2(2)],'-r','LineWidth',2);
            end
            waitforbuttonpress
            close(hf);
            fprintf('score: %f\n',scoreLineFinding(lineSet{i},lines));
        end
        % Get scores.
        if ~isempty(lines)
            scoreVec(j) = scoreLineFinding(lineSet{i},lines);
        end
    end
    scoresByPose(i).mu = mean(scoreVec);
    scoresByPose(i).s = std(scoreVec);
end
warning('on');
end

