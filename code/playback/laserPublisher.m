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
            obj.data = struct('ranges',zeros(1,obj.laserObj.nPixels),'header',struct('secs',0,'nsecs',0));
        end
        
        function setData(obj,data)
           obj.data = data;
        end
        
        function res = validInput(obj,data)
            if isstruct(data)
                if all(isfield(data,{'ranges','header'}))
                    res = 1;
                else
                    res = 0;
                end
            else
                res = 0;
            end
            
            if ~res
                error('DATA MUST BE STRUCT WITH FIELDS RANGES, HEADER.');
            end
        end
        
        function publish(obj)
           notify(obj,'OnMessageReceived',simpleEventData(obj.data)); 
        end
    end
    
end
