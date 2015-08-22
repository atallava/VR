classdef rangeSimulator < handle & abstractSimulator
    %rangeSimulator raycast in a lineMap using learned simulator
        
    properties
        % fitClass is a handle
        % pxRegBundleArray is a cell array of pixelRegressorBundle objects
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
		
		function setMap(obj,map)
			obj.map = map;
		end
        
        function res = simulate(obj,poses)
            %SIMULATE
            %
            % res = SIMULATE(obj,poses)
            %
            % poses - Length 3 array.
            %
            % res   - Output ranges.
            
            if size(poses,1) == 3
                poses = poses';
            end
            nPoses = size(poses,1);
            predParamArray = zeros(nPoses,obj.nParams,obj.laser.nBearings);
            
            % array of predicted parameters
            for i = 1:obj.nParams
                regBundle = obj.pxRegBundleArray(i);
                predParamArray(:,i,:) = regBundle.predict(poses,obj.map);
            end
            res = zeros(nPoses,obj.laser.nBearings);
            % sample from distribution given by parameters
            for i = 1:nPoses
                res(i,:) = rangeSimulator.sampleFromParamArray(squeeze(predParamArray(i,:,:)),obj.fitClass);
            end            
        end
           
        function [hArray,hCenters] = estimateHistograms(obj,poses)
            % spit out histograms at pose
            % hArray is [nPoses*nBearings,H]
            % xc is [1,H], histogram bin center
            if size(poses,1) == 3
                poses = poses';
            end
            nPoses = size(poses,1);
            predParamArray = zeros(nPoses,obj.nParams,obj.laser.nBearings);
            
            % array of predicted parameters
            for i = 1:obj.nParams
                regBundle = obj.pxRegBundleArray(i);
                predParamArray(:,i,:) = regBundle.predict(poses,obj.map);
            end
            
            % fill histograms
            nHCenters = (obj.laser.maxRange/obj.laser.rangeRes)+1; % number of histogram centers
            hCenters = linspace(0,obj.laser.maxRange,nHCenters); % histogram centers
            hArray = zeros(nPoses*obj.laser.nBearings,nHCenters);
            count = 1;
            for i = 1:nPoses
               for j = 1:obj.laser.nBearings
                   params = squeeze(predParamArray(i,:,j));
                   tempObj = obj.fitClass(struct('vec',params,'choice','params'));
                   hArray(count,:) = tempObj.snap2PMF(hCenters);
                   count = count+1;
               end
            end
        end
        
        function res = simulateGeometric(obj,poses)
            % poses is n x 3
            if size(poses,1) == 3
                poses = poses';
            end
            nPoses = size(poses,1);
            res = zeros(nPoses,obj.laser.nBearings);
            for i = 1:nPoses
                res(i,:) = obj.map.raycast(poses(i,:),obj.laser.maxRange,obj.laser.bearings);
            end
        end
        
    end
    
    methods (Static = true)
		function res = sampleFromParamArray(paramArray,fitClass)
           % paramArray is num params x num pixels
           nBearings = size(paramArray,2);
           res = zeros(1,nBearings);
           for i = 1:nBearings
               tempObj = fitClass(struct('vec',paramArray(:,i),'choice','params'));
               res(i) = tempObj.sample();
           end
        end
    end
    
end

