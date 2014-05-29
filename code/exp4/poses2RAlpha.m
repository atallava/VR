classdef poses2RAlpha < handle & abstractInputTransformer
    %poses2RAlpha transforms inputs from pose to r-alpha space for
    %different pixels
        
    properties (SetAccess = private)
        % rAlphaArrayLast is number of poses x 2 x number of bearings, cache of
        % last query
        rAlphaArrayLast
    end
    
    methods
        function obj = poses2RAlpha(inputData)
            % inputData fields ('envLineMap','laser')
            if nargin > 0
                obj.envLineMap = inputData.envLineMap;
                obj.laser = inputData.laser;
            end
        end
        
        function rAlphaArray = transform(obj,poses)
            % transform a given array of poses
            nPoses = size(poses,1);
            rAlphaArray = zeros(nPoses,1,length(obj.laser.bearings));
            
            for i = 1:nPoses
                [r,alpha] = obj.envLineMap.raycast(poses(i,:),obj.laser.maxRange,obj.laser.bearings);
                rAlphaArray(i,1,:) = r;
                rAlphaArray(i,2,:) = alpha;
            end
            obj.rAlphaArrayLast = rAlphaArray;
        end
        
        function setMap(obj,map)
            obj.envLineMap = map;
        end
    end
    
end

