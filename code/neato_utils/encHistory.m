classdef encHistory < handle
    %encHistory store encoder values in an array
    % timestamped based on robot returns
    
    properties
		% log is a struct array with fields ('left','right')
		% tArray is timestamps from robot
		% tLocalArray is system timestamps
        log
        tArray
		tLocalRelative
		ticLocal; tLocalArray
        update_count
        listenerHandle
        rob
    end
    
    methods
        function obj = encHistory(rob,refTic)
			obj.rob = rob;
            obj.log = struct('left',{},'right',{});
            obj.tArray = [];
			obj.ticLocal = tic(); 
			if nargin > 1
				% ticLocal relative to some refTic
				obj.tLocalRelative = toc(refTic);
			end
			obj.tLocalArray = [];
			obj.update_count = 0;
			obj.listenerHandle = addlistener(rob.encoders,'OnMessageReceived',@(src,evt) encHistory.encoderEventResponse(src,evt,obj));
		end
        
        function reset(obj,refTic)
            obj.listenerHandle.delete;
            pause(0.01);
            obj.log = struct('left',{},'right',{});
            obj.tArray = [];
			obj.ticLocal = tic(); 
			if nargin > 1
				% ticLocal relative to some refTic
				obj.tLocalRelative = toc(refTic);
			end
			obj.tLocalArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(obj.rob.encoders,'OnMessageReceived',@(src,evt) encHistory.encoderEventResponse(src,evt,obj));
        end
        
        function stopListening(obj)
            obj.listenerHandle.delete;
        end
        
        function delete(obj)
            if obj.listenerHandle.isvalid
                obj.listenerHandle.delete;
            end
        end
    end
            
    methods (Static)
        function encoderEventResponse(src,evt,obj)
            obj.update_count = obj.update_count+1;
            obj.tArray(obj.update_count) = evt.data.header.stamp.secs + (evt.data.header.stamp.nsecs*1e-9);
			obj.tLocalArray(obj.update_count) = toc(obj.ticLocal);
            obj.log(obj.update_count).left = evt.data.left;
            obj.log(obj.update_count).right = evt.data.right;
        end
    end
end

