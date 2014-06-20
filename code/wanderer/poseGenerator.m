classdef poseGenerator < handle
    %poseGenerator

    properties (SetAccess = private)
        map; walls; lObjArray;
        nDraws = 40;
        dRange = [0 0.5]; phiRange = pi/2*[-1 1];
        candidateBufferMaxSize = 10;
        scoringPolygon = [1 -1; 1 1; -1 1; -1 -1; 1 -1]*0.15;
        sampleHistory; poseHistory;
    end

    methods
        function obj = poseGenerator(inputData)
            % inputData fields ('map','nDraws','dRange','phiRange','candidateBufferMaxSize','scoringPolygon')
            % default (,,,,,)
            if isfield(inputData,'map')
                obj.map = inputData.map;
                obj.walls = obj.map.objects(1); % assuming the first object is the walls
                obj.lObjArray = obj.map.objects;
            else
                error('MAP NOT INPUT');
            end
            if isfield(inputData,'nDraws')
                obj.nDraws = inputData.nDraws;
            else
            end
            if isfield(inputData,'dRange')
                obj.dRange = inputData.dRange;
            else
            end
            if isfield(inputData,'phiRange')
                obj.phiRange = inputData.phiRange;
            else
            end
            if isfield(inputData,'candidateBufferMaxSize')
                obj.candidateBufferMaxSize = inputData.candidateBufferMaxSize;
            else
            end
            if isfield(inputData,'scoringPolygon')
                obj.scoringPolygon = inputData.scoringPolygon;
            else
            end
        end
        
        function sampledPose = sample(obj,pose)
            candidateBuffer = []; 
            sampledPose = [];
            for i = 1:obj.nDraws
                r = rand()*(obj.dRange(2)-obj.dRange(1))+obj.dRange(1);
                phi = rand()*(obj.phiRange(2)-obj.phiRange(1))+obj.phiRange(1);
                th = mod(pose(3)+phi,2*pi);
                poseSample = pose+[r*cos(th); r*sin(th); phi];
                sampleTraj = swingStraight(pose,poseSample);
                %currentBBox = robotModel.getTransformedBBox(poseSample);
                currentBBox = sampleTraj.bBox;
                
                % check if sample is within walls
                if ~inpolygon(poseSample(1),poseSample(2),obj.walls.lines(:,1),obj.walls.lines(:,2))
                    continue;
                end
                
                % check if sample is in collision
                %{
                obj.map.plot; hold on;
                quiver(poseSample(1),poseSample(2),0.1*cos(poseSample(3)),0.1*sin(poseSample(3)),'r','LineWidth',2);
                plot(currentBBox(:,1),currentBBox(:,2),'g'); 
                waitforbuttonpress; close all;
                %}
                inCollision = obj.checkCollision(currentBBox);
                if ~inCollision
                    candidateBuffer(:,end+1) = poseSample;
                    if size(candidateBuffer,2) == obj.candidateBufferMaxSize
                        break;
                    end
                end
            end
            
            % pick pose from candidates
            nCandidates = size(candidateBuffer,2);
            if nCandidates == 0
                warning('NO CANDIDATE POSES FOUND.');
                return;
            end
            candidateScores = zeros(1,nCandidates);
            for i = 1:nCandidates
                candidateScoringPolygon = bsxfun(@plus,obj.scoringPolygon,candidateBuffer(1:2,i)');
                temp = inpolygon(obj.poseHistory(1,:),obj.poseHistory(2,:),candidateScoringPolygon(:,1),candidateScoringPolygon(:,2));
                candidateScores(i) = exp(-sum(temp));
            end
            candidateScoresN = candidateScores/sum(candidateScores);
            id = discretesample(candidateScoresN,1);
            sampledPose = candidateBuffer(:,id); 
            obj.sampleHistory(:,end+1) = sampledPose;
        end
        
        function res = checkCollision(obj,bBox)
            res = false;
            for lobj = obj.lObjArray
                [xi,yi] = polyxpoly(bBox(:,1),bBox(:,2),lobj.lines(:,1),lobj.lines(:,2));
                if ~isempty(xi)
                    res = true;
                    break;
                end
            end
        end
        function obj = addToPoseHist(obj,pose)
            obj.poseHistory(:,end+1) = pose;
        end
    end

    methods (Static = true)
    end

end
