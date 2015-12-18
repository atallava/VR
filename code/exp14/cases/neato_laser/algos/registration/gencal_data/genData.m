% generate data from the hifi gencal laser sim

%% load the sim
% add all exp4 path here, needed by sim. 
% an option is to use the lightweight sim
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath(exp4Path));
load sim_sep6_1.mat

%% specify the map
load l_map.mat
rsim.setMap(map);

%% sample poses
nPoses = 25;
xLims = [0.1 4];
yLims = [0.1 4];
thLims = [0 2*pi];
poses = rand(3,nPoses);
poses(1,:) = range(xLims)*poses(1,:)+xLims(1);
poses(2,:) = range(yLims)*poses(2,:)+yLims(1);
poses(3,:) = range(thLims)*poses(3,:)+thLims(1);
poses(3,:) = mod(poses(3,:),2*pi);

%% sample perturbations
nPerturbations = 3; % per pose
% what are good perturbation limits
dxLims = [0.005 0.1];
dyLims = [0.005 0.1];
dthLims = deg2rad([3 15]);
perturbations = rand(3,nPoses*nPerturbations);
perturbations(1,:) = range(dxLims)*perturbations(1,:)+dxLims(1);
perturbations(2,:) = range(dyLims)*perturbations(2,:)+dyLims(1);
perturbations(3,:) = range(dthLims)*perturbations(3,:)+dthLims(1);

sensorPoses = repelem(poses,[1 nPerturbations]);
perturbedPoses = sensorPoses+perturbations;

nStates = nPoses*nPerturbations;
ranges = zeros(nStates,rsim.laser.nBearings);

%% generate range readings
for i = 1:nStates
    ranges(i,:) = rsim.simulate(sensorPoses(:,i));
end

X = struct('sensorPose',mat2cell(sensorPoses,3,ones(1,nStates)),...
    'perturbedPose',mat2cell(perturbedPoses,3,ones(1,nStates)));
Y = ranges;

%% write to file
fname = 'data_gencal';
save(fname,'X',X,'Y',Y);

%% throw away everything on exp4 path
rmpath(genpath(exp4Path));