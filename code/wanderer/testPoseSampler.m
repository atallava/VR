clear all; close all; clc;
load map;

pgen = poseGenerator(struct('map',roomLineMap));
pose = [0.25;0.25;0];
%pose = [3.492; 1.526; 12.553]; % bad pose, test for reverse maneuver
pgen.addToPoseHist(pose);
hf = roomLineMap.plot; hold on; quiver(pose(1),pose(2),0.1*cos(pose(3)),0.1*sin(pose(3)),'r','LineWidth',2);
nPoses = 100;

for i = 1:nPoses
    success = false;
    while ~success
        sampledPose = pgen.sample(pose);
        if isempty(sampledPose)
            pose = swingStraight.getBackedUpPose(pose);
            continue;
        else
            quiver(sampledPose(1),sampledPose(2),0.1*cos(sampledPose(3)),0.1*sin(sampledPose(3)),'r','LineWidth',2);
            pose = sampledPose;
            pgen.addToPoseHist(pose);
            success = true;
        end
    end
    
end


