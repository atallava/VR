classdef laserClass < handle
    %laser all relevant information about sensor being simulated
    
    properties (SetAccess = private)
        % distance unit: m
        % angle unit: rad
        maxRange
        rangeRes
        bearings
        nPixels
        nullReading
    end
    
    methods
        function obj = laserClass(inputData)
            % inputData fields ('maxRange','rangeRes','bearings','nullReading')
            % default (4.5, 0.001, deg2rad(0:359), 0)
            if isfield(inputData,'maxRange')
                obj.maxRange = inputData.maxRange;
            else
                obj.maxRange = 4.5;
            end
            if isfield(inputData,'rangeRes')
                obj.rangeRes = inputData.rangeRes;
            else
                obj.rangeRes = 0.001;
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

