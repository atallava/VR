classdef poses2R < handle & abstractInputTransformer
    %poses2R transforms inputs from pose to r space for
    %different pixels
        
    properties (SetAccess = private)
        % rArrayLast is number of poses x 2 x number of bearings, cache of
        % last query
        rArrayLast
    end
    
    methods
        function obj = poses2R(inputStruct)
            % inputStruct fields ('envLineMap','laser')
            if nargin > 0
                obj.envLineMap = inputStruct.envLineMap;
                obj.laser = inputStruct.laser;
            end
        end
        
        function rArray = transform(obj,poses)
            % transform a given array of poses
            nPoses = size(poses,1);
            rArray = zeros(nPoses,1,length(obj.laser.bearings));
            
            for i = 1:nPoses
                [r,~] = obj.envLineMap.raycast(poses(i,:),obj.laser.maxRange,obj.laser.bearings);
                rArray(i,1,:) = r;                
            end
            obj.rArrayLast = rArray;
        end
        
        function setMap(obj,map)
            obj.envLineMap = map;
        end
    end
    
end

