classdef poseGenerator < handle
    %poseGenerator

    properties (SetAccess = private)
        map; walls; lObjArray;
        nDraws = 50;
        dRange = [0.05 0.5]; phiRange = pi/2*[-1 1];
        candidateBufferMaxSize = 10;
        scoringPolygon = [1 -1; 1 1; -1 1; -1 -1; 1 -1]*0.15;
        sampleHistory; poseHistory;
    end

    methods
        function obj = poseGenerator(inputStruct)
            % inputStruct fields ('map','nDraws','dRange','phiRange','candidateBufferMaxSize','scoringPolygon')
            % default (,,,,,)
            if isfield(inputStruct,'map')
                obj.map = inputStruct.map;
                obj.walls = obj.map.objects(1); % assuming the first object is the walls
                obj.lObjArray = obj.map.objects;
            else
                error('MAP NOT INPUT');
            end
            if isfield(inputStruct,'nDraws')
                obj.nDraws = inputStruct.nDraws;
            else
            end
            if isfield(inputStruct,'dRange')
                obj.dRange = inputStruct.dRange;
            else
            end
            if isfield(inputStruct,'phiRange')
                obj.phiRange = inputStruct.phiRange;
            else
            end
            if isfield(inputStruct,'candidateBufferMaxSize')
                obj.candidateBufferMaxSize = inputStruct.candidateBufferMaxSize;
            else
            end
            if isfield(inputStruct,'scoringPolygon')
                obj.scoringPolygon = inputStruct.scoringPolygon;
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
                % get rotated bbox
                %currentBBox = robotModel.getTransformedBBox(poseSample); 
                % shortcut: get bbox for entire trajectory since we know
                % what it will be
                currentBBox = sampleTraj.bBox; 
                
                % check if sample is within walls
                if ~inpolygon(poseSample(1),poseSample(2),obj.walls.lines(:,1),obj.walls.lines(:,2))
                    continue;
                end
                
                % check if sample is in collision      
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
        
        function hf = plotPosesVsSamples(obj)
            hf = figure; hold on;
            for i = 1:length(obj.sampleHistory)
                quiver(obj.sampleHistory(1,i),obj.sampleHistory(2,i),0.1*cos(obj.sampleHistory(3,i)),0.1*sin(obj.sampleHistory(3,i)),'r','LineWidth',2);
                text(obj.sampleHistory(1,i),obj.sampleHistory(2,i),sprintf('%d',i));
                quiver(obj.poseHistory(1,i+1),obj.poseHistory(2,i+1),0.1*cos(obj.poseHistory(3,i+1)),0.1*sin(obj.poseHistory(3,i+1)),'b','LineWidth',2);
                text(obj.poseHistory(1,i+1),obj.poseHistory(2,i+1),sprintf('%d',i));
            end
            axis equal;
        end
    end

    methods (Static = true)
    end

end
