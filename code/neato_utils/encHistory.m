classdef encHistory < handle
    %encHistory store encoder values in an array
    % timestamped based on robot returns
    
    properties
        log
        tArray
        update_count
        listenerHandle
        rob
    end
    
    methods
        function obj = encHistory(rob)
            obj.rob = rob;
            obj.log = struct('left',{},'right',{});
            obj.tArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(rob.encoders,'OnMessageReceived',@(src,evt) encHistory.encoderEventResponse(src,evt,obj));
        end
        
        function obj = reset(obj)
            obj.listenerHandle.delete;
            pause(0.01);
            obj.log = struct('left',{},'right',{});
            obj.tArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(obj.rob.encoders,'OnMessageReceived',@(src,evt) encHistory.encoderEventResponse(src,evt,obj));
        end
        
        function obj = stopListening(obj)
            obj.listenerHandle.delete;
        end
    end
            
    methods (Static)
        function encoderEventResponse(src,evt,obj)
            obj.update_count = obj.update_count+1;
            obj.tArray(obj.update_count) = evt.data.header.stamp.secs + (evt.data.header.stamp.nsecs*1e-9);
            obj.log(obj.update_count+1).left = evt.data.left;
            obj.log(obj.update_count+1).right = evt.data.right;
        end
    end
end

