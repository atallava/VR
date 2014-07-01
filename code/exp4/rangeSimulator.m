classdef rangeSimulator < handle
    %rangeSimulator raycast in a lineMap using learned simulator
        
    properties (SetAccess = private)
        % fitClass is a handle
        % pxRegBundleArray is an array of pixelRegressorBundle objects
        % laser is a laserClass object, must be the same laser trained on
        % map is a lineMap object
        fitClass
        pxRegBundleArray
        nParams
        laser
        map
    end
    
    methods
        function obj = rangeSimulator(inputStruct)
            % inputStruct fields ('fitClass','pxRegBundleArray','laser','map')
            obj.fitClass = inputStruct.fitClass;
            obj.pxRegBundleArray = inputStruct.pxRegBundleArray;
            obj.nParams = length(obj.pxRegBundleArray);
            obj.laser = inputStruct.laser;
            obj.map = inputStruct.map;
        end
        
        function res = simulate(obj,poses)
            % predict parameters at poses
            % poses is n x 3
            if size(poses,1) == 3
                poses = poses';
            end
            nPoses = size(poses,1);
            predParamArray = zeros(nPoses,obj.nParams,obj.laser.nPixels);
            
            % TODO: optimize for speed
            % array of predicted parameters
            for i = 1:obj.nParams
                predParamArray(:,i,:) = obj.pxRegBundleArray(i).predict(poses,obj.map);
            end
            res = zeros(nPoses,obj.laser.nPixels);
            % sample from distribution given by parameters
            for i = 1:nPoses
                res(i,:) = rangeSimulator.sampleFromParamArray(squeeze(predParamArray(i,:,:)),obj.fitClass);
            end            
        end
                
        function res = simulateGeometric(obj,poses)
            % poses is n x 3
            if size(poses,1) == 3
                poses = poses';
            end
            nPoses = size(poses,1);
            res = zeros(nPoses,obj.laser.nPixels);
            for i = 1:nPoses
                res(i,:) = obj.map.raycast(poses(i,:),obj.laser.maxRange,obj.laser.bearings);
            end
        end
        
        function setMap(obj,map)
           obj.map = map; 
        end
    end
    
    methods (Static = true)
        function res = sampleFromParamArray(paramArray,fitClass)
           % paramArray is num params x num pixels
           nPixels = size(paramArray,2);
           res = zeros(1,nPixels);
           for i = 1:nPixels
               tempObj = fitClass(struct('vec',paramArray(:,i),'choice','params'));
               res(i) = tempObj.sample();
           end
        end
    end
    
end

