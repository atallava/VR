classdef rangeHistograms < handle
   % H is a massive array of poses x histogram x pixels
    
    properties (SetAccess = private)
        H
        nPixels
        nPoses
        bearings
        pixelIds
        maxRange = 4.5;
        deltaRange = 1e-3; % 1mm
        nCenters;
        xCenters;
    end
    
    methods
        function obj = rangeHistograms(input)
            % constructor
            obj.nPixels = input.nPixels;
           obj.nPoses = input.nPoses;
           obj.bearings = input.bearings;
           obj.pixelIds = rad2deg(obj.bearings)+1;
           if isfield(input,'maxRange')
               obj.maxRange = input.maxRange;
           end
           if isfield(input,'maxRange')
               obj.deltaRange = input.deltaRange;
           end
           obj.nCenters = (obj.maxRange/obj.deltaRange)+1;
           if floor(obj.nCenters) ~= obj.nCenters
               warning('NUMBER OF CENTERS IN HISTOGRAM HAS TO BE AN INTEGER');
           end
           obj.H = zeros(obj.nPoses,obj.nCenters,obj.nPixels);
           obj.xCenters = linspace(0,obj.maxRange,obj.nCenters);
        end
        
        function obj = fillHistogram(obj,poseId,pixelId,ranges)
            obj.H(poseId,:,pixelId) = hist(ranges,obj.xCenters);
        end
       
        function h = getHistogram(obj,poseId,pixelId)
            % get histogram for a particular pose and pixel
            h = obj.H(:,poseId,pixelId);
        end
        
        function vec = getValuesFromHistogram(obj,poseId,pixelId)
            % convert a histogram to a vector of values
            vec = [];
            for i = 1:obj.nCenters
                vec = [vec ones(1,obj.H(i,poseId,pixelId))*obj.xCenters(i)];
            end
        end
        function res = getHistograms(obj)
            res = obj.H;
        end
    end
    
end

