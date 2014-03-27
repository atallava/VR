classdef laserHistory < handle
    %laserHistory store laser values in an array
        
    properties
        rangeArray
        tArray
        update_count
        listenerHandle
        rob
    end
    
    methods
        function obj = laserHistory(rob)
            obj.rob = rob;
            obj.rangeArray = cell(0);
            obj.tArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(rob.laser,'OnMessageReceived',@(src,evt) laserHistory.laserEventResponse(src,evt,obj));
        end
        
        function obj = Reset(obj)
            obj.listenerHandle.delete;
            pause(0.01);
            obj.rangeArray = cell(0);
            obj.tArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(obj.rob.laser,'OnMessageReceived',@(src,evt) encHistory.laserEventResponse(src,evt,obj));
        end
        function obj = stopListening(obj)
            obj.listenerHandle.delete;
        end
    end
            
    methods (Static)
        function laserEventResponse(src,evt,obj)
            obj.update_count = obj.update_count+1;
            obj.tArray(obj.update_count) = evt.data.header.stamp.secs + (evt.data.header.stamp.nsecs*1e-9);
            obj.rangeArray{obj.update_count+1} = evt.data.ranges;
        end
    end
end

