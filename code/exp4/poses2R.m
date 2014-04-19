classdef poses2R < handle
    %poses2R transforms inputs from pose to r space for
    %different pixels
        
    properties
        % envLineMap is a lineMap object
        % maxRange of laser in meter
        % bearings in rad
        % posesLast is number of poses x 3, cache of last query
        % rArrayLast is number of poses x 2 x number of bearings, cache of
        % last query
        envLineMap
        maxRange = 4.5
        bearings
        posesLast
        rArrayLast
    end
    
    methods
        function obj = poses2R(inputData)
            % inputData fields ('envLineMap','maxRange','bearings')
            if nargin > 0
                obj.envLineMap = inputData.envLineMap;
                if isfield(inputData,'maxRange')
                    obj.maxRange = inputData.maxRange;
                end
                obj.bearings = inputData.bearings;
            end
        end
        
        function rArray = transform(obj,poses)
            % transform a given array of poses
            nPoses = size(poses,1);
            rArray = zeros(nPoses,1,length(obj.bearings));
            
            for i = 1:nPoses
                [r,~] = obj.envLineMap.raycast(poses(i,:),obj.maxRange,obj.bearings);
                rArray(i,1,:) = r;                
            end
            obj.rArrayLast = rArray;
        end
    end
    
end

