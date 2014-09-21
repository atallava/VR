classdef abstractSimulator < handle
    %abstractRegressor base class for simulators
    
    properties 
    end
    
    methods (Abstract)
        res = simulate(obj,poses)
    end
    
    methods 
        function setMap(obj,map)
           obj.map = map; 
        end
    end
    
end

