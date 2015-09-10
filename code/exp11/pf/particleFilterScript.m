% load readings
load pf_readings
load pf_motion_noise

%% initialize stuff
L = length(readings);
particleHistory = cell(1,L+1);
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

% initialize particles 
% uniform over map
% PARAMETERS
xyScale = 0.2;
thScale = deg2rad(2); % in rad
% particles = initParticlesUniform(map,support,xyScale,thScale,bBox);

% around initial guess
% PARAMETERS
xyScale = 0.1;
thScale = deg2rad(2); % in rad
particles = initParticlesAroundPose(map,support,xyScale,thScale,bBox,poseHistory(:,1));

% reduce particle set
% PARAMETERS
PMax = 1e2;
P = length(particles);
if P > PMax
    ids = randsample(1:P,PMax);
    particles = particles(ids);
end

particleHistory{1} = particles;

% PARAMETERS
powerScale = 0.1;
bearingSkip = 10;

%% process readings
% CHECK PARAMETERS!
plotOption = 1;

clockLocal = tic();
for i = 1:L
    data = readings(i).data;
    if strcmp(readings(i).type,'motion')
        % motion update
        particles = motionUpdate(particles,data.VArray,data.wArray,data.dtArray,etaV,etaW);
        particles = pruneInvalidPoses(particles,map,support,bBox);
    else
        % observation update
        % subsample 
        ranges = data.ranges; bearings = sensor.bearings;
        [ranges,bearings] = subsampleRanges(ranges,bearings,bearingSkip);
        % get weights from sensor model
        weights = getWeightsGaussian(map,sensor,ranges,bearings,particles);
        weights = powerScaleWeights(weights,powerScale);
        weights = weights/sum(weights);
        % resample
        particles = resampleParticles(particles,weights);
    end
    if plotOption
       vizParticles(map,particles,poseHistory(:,round(0.5*(i+1))));
       title(sprintf('t: %.2fs',tHistory(round(0.5*(i+1)))));
       pause(1);
       close all;
    end
    particleHistory{i+1} = particles;
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save results
fname = 'pf_run';
save(fname,...
    'particleHistory');