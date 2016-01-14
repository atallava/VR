% generate sim data

%% load sim
% an option is to use the lightweight sim
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath(exp4Path));
load rsim_sep6_2.mat;

%% load map
load l_map.mat
rsim.setMap(map);

%% sample poses
nPoses = 150;
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

sensorPoses = repelem(poses,1,nPerturbations);
perturbedPoses = sensorPoses+perturbations;

nStates = nPoses*nPerturbations;
ranges = zeros(nStates,rsim.laser.nBearings);

%% generate range readings
clockLocal = tic();
for i = 1:nStates
    ranges(i,:) = rsim.simulate(sensorPoses(:,i));
end
fprintf('genData:Computation time: %.2fs.\n',toc(clockLocal));

X = struct('sensorPose',mat2cell(sensorPoses,3,ones(1,nStates)),...
    'perturbedPose',mat2cell(perturbedPoses,3,ones(1,nStates)),...
    'map',map);
Y = struct('ranges',mat2cell(ranges,ones(1,nStates),size(ranges,2))');

%% write to file
fname = 'data_gencal_2';
save(fname,'X','Y');

%% throw away everything on exp4 path
rmpath(genpath(exp4Path));