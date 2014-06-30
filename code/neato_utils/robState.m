classdef robState < handle
    % class to update pose estimates based on encoder values
    % attach an instance of this class to a real or sim neato
    % under robot mode to listen to encoder events
    % use manual mode to set encoder values by hand
    
    properties (Constant = true)
        HISTORY_SIZE = 5000;
    end
    properties
        rob
        pose
        mode
        pose_history; t_history
        update_count; motion_count
        listenerHandle
        encoders = struct('data',struct('left',0,'right',0))
        left_enc_old; right_enc_old
        t_start; t_old
        vl; vr
        first_time
    end
    
    methods
        function obj = robState(rob,mode,pose)
            obj.rob = rob;
            if nargin < 3
                obj.pose = [0;0;0];
            else
                obj.pose = pose;
            end
            if nargin < 2
                obj.mode = 'robot';
            else
                obj.mode = mode;
            end
            
            obj.pose_history = zeros(3,obj.HISTORY_SIZE);
            obj.t_history = zeros(1,obj.HISTORY_SIZE);
            obj.update_count = 0;
            obj.motion_count = 1;
            obj.first_time = true;
            if strcmp(obj.mode,'robot')
                obj.listenerHandle = addlistener(rob.encoders,'OnMessageReceived',@(src,evt) robState.encoderEventResponse(src,evt,obj));
            end
        end
        
        function setEncoders(obj,enc,t)
            % enc is a struct with fields left and right
            % t is the timestamp of the values
            if ~strcmp(obj.mode,'manual')
                warning('FUNCTION TO BE USED ONLY IN MANUAL MODE');
            end
            obj.update_count = obj.update_count+1;
            tstamp = t;
            obj.encoders.data.left = enc.left;
            obj.encoders.data.right = enc.right;
            % initialize values if first time
            if obj.first_time
                obj.t_start = tstamp;
                obj.t_old = tstamp;
                obj.left_enc_old = enc.left;
                obj.right_enc_old = enc.right;
                obj.vl = 0;
                obj.vr = 0;
                obj.first_time = false;
                obj.pose_history(:,1) = obj.pose;
                obj.t_history(1) = 0;
                obj.motion_count = obj.motion_count + 1;
            else
                obj.updatePose(tstamp);
            end
        end
        
        function updatePose(obj,t_new)
            % updates based on encoders
            
            % don't perform calculations if encoders don't change
            if (obj.encoders.data.left == obj.left_enc_old) && (obj.encoders.data.right == obj.right_enc_old)
                obj.t_old = t_new;
                obj.vl = 0;
                obj.vr = 0;
                return
            end
            
            dt = t_new-obj.t_old;
            obj.vl = (obj.encoders.data.left-obj.left_enc_old)/1000/dt;
            obj.vr = (obj.encoders.data.right-obj.right_enc_old)/1000/dt;
            [V,w] = robotModel.vlvr2Vw(obj.vl,obj.vr);
            
            obj.pose(3) = obj.pose(3)+w*dt; obj.pose(3) = mod(obj.pose(3),2*pi);
            obj.pose(1) = obj.pose(1)+V*cos(obj.pose(3))*dt;
            obj.pose(2) = obj.pose(2)+V*sin(obj.pose(3))*dt;
            obj.left_enc_old = obj.encoders.data.left;
            obj.right_enc_old = obj.encoders.data.right;
            obj.t_old = t_new;
            
            % update history arrays
            obj.pose_history(:,obj.motion_count) = obj.pose;
            obj.t_history(obj.motion_count) = t_new-obj.t_start;
            obj.motion_count = obj.motion_count+1;
        end
        
        function reset(obj,pose)
            % delete history and start over
            if strcmp(obj.mode,'robot')
                obj.listenerHandle.delete();
            end
            if nargin > 0
                obj.pose = pose;
            else
                obj.pose = [0;0;0];
            end
            obj.pose_history = zeros(3,obj.HISTORY_SIZE);
            obj.t_history = zeros(1,obj.HISTORY_SIZE);
            obj.motion_count = 1;
            obj.update_count = 0;
            obj.first_time = true;
            if strcmp(obj.mode,'robot')
                obj.listenerHandle = addlistener(obj.rob.encoders,'OnMessageReceived',@(src,evt) robState.encoderEventResponse(src,evt,obj));
            end
        end
        
    end
    
   methods (Static)
     function encoderEventResponse(src,evt,obj)
         obj.update_count = obj.update_count+1;
         tstamp = evt.data.header.stamp.secs + (evt.data.header.stamp.nsecs*1e-9);
         obj.encoders.data.left = evt.data.left;
         obj.encoders.data.right = evt.data.right;
         % initialize values if first time 
         if obj.first_time
             obj.t_start = tstamp;
             obj.t_old = tstamp;
             obj.left_enc_old = evt.data.left;
             obj.right_enc_old = evt.data.right;
             obj.vl = 0;
             obj.vr = 0;
             obj.first_time = false;
             obj.pose_history(:,1) = obj.pose;
             obj.t_history(1) = 0;
             obj.motion_count = obj.motion_count + 1;
         else
             obj.updatePose(tstamp);
         end
     end
    end
end
