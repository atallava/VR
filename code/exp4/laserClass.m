classdef laserClass < handle
    %laser all relevant information about sensor being simulated
    
    properties (SetAccess = private)
        % distance unit: m
        % angle unit: rad
        maxRange
        resolution
        bearings
        nPixels
        nullReading
    end
    
    methods
        function obj = laserClass(inputData)
            % inputData fields ('maxRange','resolution','bearings','nullReading')
            % default (4.5, 0.001, deg2rad(0:359), 0)
            if isfield(inputData,'maxRange')
                obj.maxRange = inputData.maxRange;
            else
                obj.maxRange = 4.5;
            end
            if isfield(inputData,'resolution')
                obj.resolution = inputData.resolution;
            else
                obj.resolution = 0.001;
            end
            if isfield(inputData,'bearings')
                obj.bearings = inputData.bearings;
            else
                obj.bearings = deg2rad(0:359);
            end
            obj.nPixels = length(obj.bearings);
            if isfield(inputData,'nullReading')
                obj.nullReading = inputData.nullReading;
            else
                obj.nullReading = 0;
            end
        end
    end
    
end

