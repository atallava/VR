function statsByPose = testScanMatch(choice)
% choice: {'real','baseline','sim','sim_pooled','sim_local_match'}
addpath(genpath('../'));
addpath ../../wanderer/
load application_test_data
load ../mats/processed_data_mar27.mat
load ../mats/roomLineMap

switch choice
    case 'real'
        % nothing to be done
    case {'sim','baseline'}
        load('../mats/full_predictor_mar27_1','rsim');
        rsim.setMap(map);
    case 'sim_pooled'
        load('../mats/full_predictor_mar27_4','rsim');
        rsim.setMap(map);
    case 'sim_local_match'
        load('../mats/full_predictor_mar27_5','rsim');
        rsim.setMap(map);
    otherwise
        error('INVALID CHOICE.');
end
warning('off');        
localizer = lineMapLocalizer(map.objects);
laser = laserClass(struct());
refiner = laserPoseRefiner(struct('localizer',localizer,'numIterations',30));
%nObs = size(data(1).ranges,1);
nObs = 10;
t1 = tic();
for i = 1:length(data)
    fprintf('Pose %d...\n',i);
    for j = 1:length(patternSet)
        if mod(j,10) == 0
            fprintf('Pattern %d...\n',j);
        end
        vec1 = []; vec2 = [];
        poseIn = data(i).pose+patternSet(:,j);
        for k = 1:nObs
            switch choice
                case 'real'
                    ranges = data(i).ranges(k,:);
                case 'baseline'
                    ranges = map.raycastNoisy(data(i).pose,laser.maxRange,laser.bearings);
                case {'sim','sim_pooled','sim_local_match'}
                    ranges = rsim.simulate(data(i).pose);
            end
            [success,poseOut] = refiner.refine(ranges,poseIn);
            vec1(end+1) = success.err;
            vec2(end+1) = pose2D.poseNorm(poseOut,data(i).pose);
        end
        stats(j).pointError.mu = mean(vec1); stats(j).pointError.s = sqrt(var(vec1));
        stats(j).poseError.mu = mean(vec2); stats(j).poseError.s = sqrt(var(vec2));
    end
    statsByPose(i).errorStats = stats;
end
warning('on');
fprintf('Total computation took %ds.\n',toc(t1));
end