classdef sensorListener < handle
    
    properties
        data
        listenerHandle
    end
    
    methods
        function obj = sensorListener(sensorPublisherObj)
            obj.listenerHandle = addlistener(sensorPublisherObj,'OnMessageReceived',@(src,evt) sensorListener.eventResponse(src,evt,obj));
        end
    end
    
    methods (Static = true)
        function eventResponse(src,evt,obj)
            obj.data = evt.data;
        end
    end
end

