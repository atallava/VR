classdef rangeHistograms < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        H
        nObs
        nPixels
        nPoses
        bearings
        maxRange = 4;
        deltaRange = 1e-3; % 1mm
        nCenters;
        xcenters;
    end
    
    methods
        function obj = rangeHistograms(nObs,nPixels,nPoses,bearings,maxRange,deltaRange)
            % constructor
           obj.nObs = nObs; 
           obj.nPixels = nPixels;
           obj.nPoses = nPoses;
           obj.bearings = bearings;
           if nargin > 4
               obj.maxRange = maxRange;
               obj.deltaRange = deltaRange;
           end
           obj.nCenters = (obj.maxRange/obj.deltaRange)+1;
           if floor(obj.nCenters) ~= obj.nCenters
               warning('NUMBER OF CENTERS IN HISTOGRAM HAS TO BE AN INTEGER');
           end
           obj.H = zeros(obj.nCenters,obj.nPoses,obj.nPixels);
           obj.xcenters = linspace(0,obj.maxRange,obj.nCenters);
        end
        
        function obj = fillHistogram(obj,poseId,pixelId,ranges)
            % ranges is a vector of values collected over nObs observations
            % convert to a histogram and store
            obj.H(:,poseId,pixelId) = hist(ranges,obj.xcenters);
        end
       
        function h = getHistogram(obj,poseId,pixelId)
            % get histogram for a particular pose and pixel
            h = obj.H(:,poseId,pixelId);
        end
        
        function vec = getValuesFromHistogram(obj,poseId,pixelId)
            % convert a histogram to a vector of values
            vec = [];
            for i = 1:obj.nCenters
                vec = [vec ones(1,obj.H(i,poseId,pixelId))*obj.xcenters(i)];
            end
        end
        function res = getHistograms(obj)
            res = obj.H;
        end
    end
    
end

