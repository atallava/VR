classdef baselineSimulator < abstractSimulator
    % Naive simulation
    
    properties
        laser
        map
    end
    
    methods
        function obj = baselineSimulator(inputStruct)
            % inputStruct fields ('laser','map')
            obj.laser = inputStruct.laser;
            if isfield(inputStruct,'map')
                obj.map = inputStruct.map;
            end
        end
        
        
        function res = simulate(obj,poses)
            %SIMULATE
            %
            % res = SIMULATE(obj,poses)
            %
            % poses - Length 3 array.
            %
            % res   - Output ranges.
            
            if isempty(obj.map)
                error('MAP HAS NOT BEEN SET.');
            end
            if size(poses,1) == 3
                poses = poses';
            end
            
            nPoses = size(poses,1);
            res = zeros(nPoses,obj.laser.nPixels);
            for i = 1:nPoses
                res(i,:) = obj.map.raycastNoisy(poses(i,:),obj.laser.maxRange,obj.laser.bearings);
            end
        end
        
    end
    
end

