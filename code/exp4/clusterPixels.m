classdef clusterPixels < handle
    %clusterPixels get clusters of pixel inlier/ outlier ids for use in
    % local matching

    properties (SetAccess = private)
        laser = laserClass(struct())
        minOutClusterLength = 3;
        maxInClusterLength = 10;
        minInClusterLength = 5;
    end

    methods
        function obj = clusterPixels(inputStruct)
            % inputStruct fields ('laser','maxInClusterLength','minInClusterLength','minOutClusterLength')
            % default (laserClass(struct()))
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
            end
            if isfield(inputStruct,'minOutClusterLength')
                obj.minOutClusterLength = inputStruct.minOutClusterLength;
            else
            end
            if isfield(inputStruct,'maxInClusterLength')
                obj.maxInClusterLength = inputStruct.maxInClusterLength;
            else
            end
            if isfield(inputStruct,'minInClusterLength')
                obj.minInClusterLength = inputStruct.minInClusterLength;
            else
            end
        end
        
        function outClusters = getOutClusters(obj,outIds)
            % outIds are outlier ids
            % outClusters is a struct array with field 'members' of
            % ids in laser
            
            if isempty(outIds)
                outClusters = struct('members',{});
                return;
            end
                                 
            nOuts = length(outIds);
            % outIdsClusters is a struct array with fields 'first','last'
            % of ids corresponding to outIds
            outIdsClusters = struct('first',{},'last',{});
            count = 1;
            outIdsClusters(count).first = 1;
            next = 1;
            
            while next <= nOuts
                if circArray.circDiff(outIds(outIdsClusters(count).first),outIds(next),obj.laser.nPixels) ~= circArray.circDiff(outIdsClusters(count).first,next,nOuts)
                    [last,~] = circArray.circNbrs(next,nOuts);
                    outIdsClusters(count).last = last;
                    count = count+1;
                    outIdsClusters(count).first = next;
                end
                next = next+1;
            end
            outIdsClusters(count).last = nOuts;
            
            % connect circle if needed
            if circArray.circDiff(outIds(outIdsClusters(end).last),outIds(outIdsClusters(1).first),obj.laser.nPixels) == 1
                outIdsClusters(1).first = outIdsClusters(end).first;
                outIdsClusters(end) = [];
            end
            
            % weed out short clusters
            throw = [];
            for i = 1:length(outIdsClusters)
                if circArray.circDiff(outIdsClusters(i).first,outIdsClusters(i).last,nOuts) < obj.minOutClusterLength
                    throw = [throw i];
                end
            end
            outIdsClusters(throw) = [];
            
            outClusters = struct('members',{});
            for i = 1:length(outIdsClusters)
                outClusters(i).members = circArray.getCircSection(outIds(outIdsClusters(i).first),outIds(outIdsClusters(i).last),obj.laser.nPixels);
            end
        end
        
        function inClusters = getInClusters(obj,outClusters,inIds)
            % outClusters is a struct array with fields 'first','last' of
            % ids in laser
            
            inClusters = struct('members',{});
            if isempty(outClusters)
                [vec1,vec2] = clusterPixels.splitVector(1,obj.laser.nPixels,obj.minInClusterLength,obj.maxInClusterLength);
                for j = 1:length(vec1)
                    section = circArray.getCircSection(vec1(j),vec2(j),obj.laser.nPixels);
                    section = intersect(section,inIds);
                    inClusters(end+1).members = section;
                end
            else
                for i = 1:length(outClusters)
                    [left,~] = circArray.circNbrs(i,length(outClusters));
                    [~,first] = circArray.circNbrs(outClusters(left).members(end),obj.laser.nPixels);
                    [last,~] = circArray.circNbrs(outClusters(i).members(1),obj.laser.nPixels);
                    if first > last
                        dummyLast = circArray.circDiff(first,last,obj.laser.nPixels);
                        [vec1,vec2] = clusterPixels.splitVector(0,dummyLast,obj.minInClusterLength,obj.maxInClusterLength);
                        vec1 = circArray.projectToCircIds(vec1+first,obj.laser.nPixels);
                        vec2 = circArray.projectToCircIds(vec2+first,obj.laser.nPixels);
                    else
                        [vec1,vec2] = clusterPixels.splitVector(first,last,obj.minInClusterLength,obj.maxInClusterLength);
                    end
                    for j = 1:length(vec1)
                        section = circArray.getCircSection(vec1(j),vec2(j),obj.laser.nPixels);
                        section = intersect(section,inIds);
                        inClusters(end+1).members = section;
                    end
                end
            end
        end
    end

    methods (Static = true)
        function [vec1,vec2] = splitVector(first,last,minLength,maxLength)
            % break first to last continuous segment into chunks
            % vec1 is start of chunk, vec2 is end of chunks
            % last must be greater than first
            % if already smaller than minLength, first and last are
            % returned in vec1, vec2
            
            if last-first+1 <= maxLength
                vec1 = first;
                vec2 = last;
            else
                vec1 = first:maxLength:last;
                r = last-vec1(end)+1;
                if r > 0 && r < minLength
                    vec1(end) = last-minLength+1;
                end
                vec2 = [vec1(2:end)-1 last];
            end
        end        
    end

end
