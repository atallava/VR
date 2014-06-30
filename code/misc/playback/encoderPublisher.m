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
           obj.data = struct('left',[],'right',[]);
        end
        
        function setData(obj,data)
            validInput = 1;
            if isstruct(data)
                if all(isfield(data,{'left','right'}))
                    obj.data = data;
                else
                    validInput = 0;
                end
            else
                validInput = 0;
            end
            
            if ~validInput
                error('DATA MUST BE STRUCT WITH FIELDS LEFT, RIGHT.');
            end
        end
        
        function publish(obj)
           notify(obj,'OnMessageReceived',simpleEventData(obj.data)); 
        end
    end
    
end

