classdef callbackData < event.EventData
    % callbackData generic event specific data class
    
    properties
        data
    end
    
    methods
        function obj = callbackData(data)
            obj.data = data;
        end
    end
    
end

