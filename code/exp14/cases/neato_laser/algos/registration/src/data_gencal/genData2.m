% init
situationNames = {'situation_l_map_1','situation_l_map_2','situation_l_map_3','situation_l_map_4',...
    'situation_competition_map'};
nSituations = length(situationNames);

elementsPerSituation = [0 0 0 30, ...
    0];
if numel(elementsPerSituation) == 1
    elementsPerSituation = elementsPerSituation*ones(1,nSituations);
end
nElements = sum(elementsPerSituation);

instancesPerSituationElement = 1;
if numel(instancesPerSituationElement) == 1
    instancesPerSituationElement = instancesPerSituationElement*ones(1,nSituations);
end

% will losses from each situation have to be normalized?

%% load sim
% an option is to use the lightweight sim
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath(exp4Path));
load rsim_sep6_2.mat;

%% generate data
dataset = struct('X',{},'Y',{});
bBox = robotModel.bBox;
count = 1;
for i = 1:nSituations
    situationName = situationNames{i};
    fname = ['../data/' situationName];
    load(fname,'map','refMap','support','perturbationLims');
    nInstances = instancesPerSituationElement(i);
    lims = cell2mat(struct2cell(perturbationLims));
    lims = lims';
    for j = 1:elementsPerSituation(i)
        % sample poses
        sensorPoses = uniformSamplesOnSupport(map,support,bBox,nInstances)'; % [3,nInstances]
        perturbations = uniformSamplesInRange(lims,nInstances); % [nInstances,3]
        perturbedPoses = sensorPoses+perturbations';
        X = struct('sensorPose',{},'perturbedPose',{},'map',{},'refMap',{});
        Y = struct('ranges',{});
        for k = 1:nInstances
            X(k).sensorPose = sensorPoses(:,k);
            X(k).perturbedPose = perturbedPoses(:,k);
            X(k).map = map;
            X(k).refMap = refMap;
            
            % generate ranges
            rsim.setMap(map);
            Y(k).ranges = rsim.simulate(X(k).sensorPose);
        end
        dataset(count).X = X;
        dataset(count).Y = Y;
        count = count+1;
    end
end

%% save to file
fname = 'data_gencal_l_far_clutter';
save(fname,'dataset');

%% clean path
rmpath(genpath(exp4Path));
