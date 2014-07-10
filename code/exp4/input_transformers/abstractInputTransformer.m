classdef (Abstract) abstractInputTransformer < handle
    %abstractRegressor base class for transforming inputs from pose space
    
    properties (SetAccess = protected)
        % envLineMap is a lineMap object
        % laser is a laserClass object
        % posesLast is number of poses x 3, cache of last query
        envLineMap
        laser
        posesLast       
    end
    
    methods (Abstract)
        transform(obj,poses)
        setMap(obj,map)
    end
    
end

