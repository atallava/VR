classdef laserPublisher < handle
    %laserPublisher
    
    events
        OnMessageReceived
    end
    
    properties (SetAccess = private)
        laserObj
        data
    end
    
    methods
        function obj = laserPublisher(laserObj)
            obj.laserObj = laserObj;
            obj.data = struct('ranges',zeros(1,obj.laserObj.nPixels));
        end
        
        function setData(obj,data)
            validInput = 1;
            if isstruct(data)
                if isfield(data,'ranges')
                    obj.data = data;
                else
                    validInput = 0;
                end
            else
                validInput = 0;
            end
            
            if ~validInput
                error('DATA MUST BE STRUCT WITH FIELD RANGES.');
            end
        end
        
        function publish(obj)
           notify(obj,'OnMessageReceived',simpleEventData(obj.data)); 
        end
    end
    
end
