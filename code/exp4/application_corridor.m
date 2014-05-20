%observe predictor behaviour in some other environment
% just for kicks
clear all; clc; close all;

load corridor
load full_predictor_mar27_1

poses = [0.1 0.5 0; 0.5 1.75 deg2rad(30); 3.5 1.5 pi/2]';
nPoses = size(poses,2);

%% predict at poses

predMuArray = muPxRegBundle.predict(poses',corridor);
predSigmaArray = sigmaPxRegBundle.predict(poses',corridor);
predPzArray = pzPxRegBundle.predict(poses',corridor);

paramArray(:,1,:) = predMuArray;
paramArray(:,2,:) = predSigmaArray;
paramArray(:,3,:) = predPzArray;

%% sample from predictions and plot
figure; 
plot(walls.lines(:,1),walls.lines(:,2),'linewidth',2);
hold on;
xl0 = xlim; yl0 = ylim;
xlabel('x (m)'); ylabel('y (m)');

for i = 1:nPoses
    xRob = poses(1,i); yRob = poses(2,i); thRob = poses(3,i);
    quiver(xRob,yRob,0.2*cos(thRob),0.2*sin(thRob),'k','LineWidth',2);
    
    rangesSim = sampleFromParamArray(squeeze(paramArray(i,:,:)),@normWithDrops);
        
    xSim = xRob+rangesSim.*cos(dp.laser.bearings+thRob);
    ySim = yRob+rangesSim.*sin(dp.laser.bearings+thRob);
    plot(xSim,ySim,'ro');
    %{
    annotation('textbox',[.6,0.8,.1,.1], ...
    'String', {'blue: walls','red: simulated ranges','black: robot'});
    %}
end

dilation = [-0.5 0.5];
xlim(xl0+dilation); ylim(yl0+dilation);
