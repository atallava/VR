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
nPerturbations = 1; % per pose
% what are good perturbation limits
dxLims = [0.005 0.05];
dyLims = [0.005 0.05];
dthLims = deg2rad([-5 5]);
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

for i = 1:nStates
    X.sensorPose = sensorPoses(:,i);
    X.perturbedPose = perturbedPoses(:,i);
    X.map = map;
    X.refMap = map;
    dataset(i).X = X;
    dataset(i).Y = ranges(i,:);
end

%% write to file
fname = 'data_gencal_2';
save(fname,'dataset');

%% throw away everything on exp4 path
rmpath(genpath(exp4Path));