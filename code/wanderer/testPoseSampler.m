clear all; close all; clc;
load map;
robot.body = [0.165 -0.165; 0.165 0.165; -0.165 0.165; -0.165 -0.165; 0.165 -0.165];
objArray = roomLineMap.objects;
pose = [0.5; 0.5; 0];
nPoses = 50;
nPoseSamples = 40;
poseSampleBuffer = [];
poseSampleBufferMaxSize = 10;
robot.radius = 0.5;
robot.phiRange = pi/2*[-1 1];
poseHistory(:,1) = pose;
robot.scoringPolygon = [1 -1; 1 1; -1 1; -1 -1; 1 -1]*0.1;

walls = roomLineMap.objects(1);

hf = roomLineMap.plot; hold on;
for i = 1:nPoses
    fprintf('pose %d\n',i);
    poseSampleBuffer = [];
    for j = 1:nPoseSamples
        r = rand()*robot.radius; phi = rand()*(robot.phiRange(2)-robot.phiRange(1))+robot.phiRange(1);
        th = pose(3)+phi;
        poseSample = pose+[r*cos(th); r*sin(th); phi];
        p2d = pose2D(poseSample);
        currentBody = p2d.Tb2w*[robot.body'; ones(1,size(robot.body,1))];
        currentBody(3,:) = []; currentBody = currentBody';
        %currentBody = bsxfun(@plus,robot.body,poseSample(1:2)');
        inWalls = true;
        
        if ~inpolygon(poseSample(1),poseSample(2),walls.lines(:,1),walls.lines(:,2))
            inWalls = false;
            continue;
        end
        
        inCollision = false;
        for lobj = objArray
            [xi,yi] = polyxpoly(currentBody(:,1),currentBody(:,2),lobj.lines(:,1),lobj.lines(:,2));
            if ~isempty(xi)
                inCollision = true;
                break;
            end
        end
        if ~inCollision
            poseSampleBuffer(:,end+1) = poseSample;
            if size(poseSampleBuffer,2) == poseSampleBufferMaxSize
                break;
            end
        end
    end
    nSamplesFound = size(poseSampleBuffer,2);
    if nSamplesFound == 0
        error('no feasible poses found');
    end
    poseSampleScores = zeros(1,nSamplesFound);
    for j = 1:nSamplesFound
        scoringPolygon = bsxfun(@plus,robot.scoringPolygon,poseSampleBuffer(1:2,j)');
        temp = inpolygon(poseHistory(1,:),poseHistory(2,:),scoringPolygon(:,1),scoringPolygon(:,2));
        poseSampleScores(j) = exp(-sum(temp));
    end    
    poseSampleScoresN = poseSampleScores/sum(poseSampleScores);
    id = discretesample(poseSampleScoresN,1);
    pose = poseSampleBuffer(:,id); p2d = pose2D(pose);
    currentBody = p2d.Tb2w*[robot.body'; ones(1,size(robot.body,1))];
    currentBody(3,:) = []; currentBody = currentBody';
    poseHistory(:,end+1) = pose;
    
    quiver(pose(1),pose(2),0.1*cos(pose(3)),0.1*sin(pose(3)),'r','LineWidth',2);
    plot(currentBody(:,1),currentBody(:,2),'r');
    %waitforbuttonpress
end


