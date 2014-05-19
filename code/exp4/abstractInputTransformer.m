classdef (Abstract) abstractInputTransformer < handle
    %abstractRegressor base class for transforming inputs from pose space
    
    properties (Abstract, SetAccess = private)
        % envLineMap is a lineMap object
        % maxRange of laser in meter
        % bearings in rad
        % posesLast is number of poses x 3, cache of last query
        envLineMap
        maxRange
        bearings
        posesLast       
    end
    
    methods (Abstract)
        transform(obj,poses)
        setMap(obj,map)
    end
    
end

