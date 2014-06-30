classdef encoderPublisher < handle
    %encoderPublisher
    
    events
        OnMessageReceived
    end
    
    properties (SetAccess = private)
        data
    end
    
    methods
        function obj = encoderPublisher()
           obj.data = struct('left',[],'right',[],'header',struct('secs',0,'nsecs',0));
        end
        
        function setData(obj,data)
            obj.data = data;
        end
        
        function res = validInput(obj,data)
            if isstruct(data)
                if all(isfield(data,{'left','right','header'}))
                    res = 1;
                else
                    res = 0;
                end
            else
                res = 0;
            end
            
            if ~res
                error('DATA MUST BE STRUCT WITH FIELDS LEFT, RIGHT, HEADER.');
            end
        end
        
        function publish(obj)
           notify(obj,'OnMessageReceived',simpleEventData(obj.data)); 
        end
    end
    
end

