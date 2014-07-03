classdef nullFraction < handle 
    %nullFraction.m

    properties (SetAccess = private)
        bearings = deg2rad(0:359)
        pixelIds
        null_bearings
    end

    methods
        function obj = nullFraction(inputStruct)
            % inputStruct fields ('bearings')
            % default (deg2rad(0:359))
            if isfield(inputStruct,'bearings')
                obj.bearings = inputStruct.bearings;
            else
            end
            obj.pixelIds = round(rad2deg(obj.bearings)+1);
            load null_vs_bearings;
            obj.null_bearings = null_feb7;
        end
        
        function res = predict(obj,X,map)
            nQueries = size(X,1);
            res = repmat(obj.null_bearings(obj.pixelIds),nQueries,1);
        end
    end

    methods (Static = true)
    end

end
