% load readings
fnameReadings = '../data/pf_readings';
load(fnameReadings, ...
    'map','poseHistory','readings','sensor','support','tHistory','traj');

debugFlag = 1;

%% initialize
% robot bounding box
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

% initialize particles 
% PARAMETERS
xyScale = 0.1;
thScale = deg2rad(2); % in rad
% uniform over map
% initDistSampler = @initParticlesUniform;
% around initial pose
initDistSampler = @(map,support,bBox,xyScale,thScale) ...
    initParticlesAroundPose(map,support,bBox,xyScale,thScale,poseHistory(:,1));

particles = initDistSampler(map,support,bBox,xyScale,thScale);

% limit number of particles
% PARAMETERS
PMax = 1e2;
P = length(particles);
if P > PMax
    ids = randsample(1:P,PMax);
    particles = particles(ids);
end

% motion model
% PARAMETERS
fnameMotionNoise = '../data/pf_motion_noise';
load(fnameMotionNoise,'etaV','etaW');

% observation model
% PARAMETERS
bearingSkip = 10;
powerScale = 0.1;
% gaussian
obsModel = @getWeightsGaussian;

% resampling
resampler = @vanillaResampler;

if debugFlag
    fprintf('Initial distribution parameters:\n');
    fprintf(['xyScale: %.4f\n' ...
        'thScale: %.4f\n' ...
        'initDistSampler: %s\n' ...
        'PMax: %d\n\n'], ...
        xyScale,thScale,func2str(initDistSampler),PMax);
    
    fprintf('Motion model parameters:\n');
    fprintf(['etaV: %.4f\n' ....
        'etaW: %.4f\n\n'], ...
        etaV,etaW);
    
    fprintf('Observation model parameters:\n');
    fprintf(['model: %s\n' ...
        'powerScale: %.4f\n' ...
        'bearing skip: %d\n\n'], ...
        func2str(obsModel),powerScale,bearingSkip);
    
    fprintf('Resampling parameters:\n');
    fprintf(['resampler: %s\n\n'], ...
        func2str(resampler));
end

%% process readings
% CHECK PARAMETERS!
plotOption = 1;

L = length(readings);

% logs
particlesLog = cell(1,L+1);
particlesLog{1} = particles;
weightsLog = cell(1,L);

clockLocal = tic();
for i = 1:L
    data = readings(i).data;
    if strcmp(readings(i).type,'motion')
        % motion update
        particles = motionUpdate(particles,data.VArray,data.wArray,data.dtArray,etaV,etaW);
        particles = pruneInvalidPoses(particles,map,support,bBox);
    else
        % observation update
        % subsample ranges
        ranges = data.ranges; 
        bearings = sensor.bearings;
        [ranges,bearings] = subsampleRanges(ranges,bearings,bearingSkip);

        % get weights from sensor model
        weights = obsModel(map,sensor,ranges,bearings,particles);
        weights = powerScaleWeights(weights,powerScale);
        
        % resample
        particles = resampler(particles,weights);
    end
    if plotOption
       vizParticles(map,particles,weights);
       title(sprintf('t: %.4fs',tHistory(i)));
       pause(1);
       close all;
    end
    particlesLog{i+1} = particles;
    weightsLog{i} = weights;
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save results
fnameRes = '../pf_run';
save(fnameRes,...
    'particlesLog','weightsLog');

