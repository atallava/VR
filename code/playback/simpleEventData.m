classdef simpleEventData < event.EventData
    %simpleEventData
    
    properties
        data
    end
    
    methods
        function obj = simpleEventData(data)
            obj.data = data;
        end
    end

end

