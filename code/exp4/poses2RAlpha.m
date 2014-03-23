classdef poses2RAlpha < handle
    %poses2RAlpha transforms inputs from pose to r-alpha space for
    %different pixels
        
    properties
        % envLineMap is a lineMap object
        % maxRange of laser in meter
        % bearings in rad
        % posesLast is number of poses x 3, cache of last query
        % rAlphaArray is number of poses x 2 x number of bearings, cache of
        % last query
        envLineMap
        maxRange = 4
        bearings
        posesLast
        rAlphaArrayLast
    end
    
    methods
        function obj = poses2RAlpha(inputData)
            % inputData fields ('envLineMap','maxRange','bearings')
            if nargin > 0
                obj.envLineMap = inputData.envLineMap;
                if isfield(inputData,'maxRange')
                    obj.maxRange = inputData.maxRange;
                end
                obj.bearings = inputData.bearings;
            end
        end
        
        function rAlphaArray = transform(obj,poses)
            % transform a given array of poses
            nPoses = size(poses,1);
            rAlphaArray = zeros(nPoses,2,length(obj.bearings));
            
            for i = 1:nPoses
                [r,alpha] = obj.envLineMap.raycast(poses(i,:),obj.maxRange,obj.bearings);
                rAlphaArray(i,1,:) = r;
                rAlphaArray(i,2,:) = alpha;
            end

        end
    end
    
end

