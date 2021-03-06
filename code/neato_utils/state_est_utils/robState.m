classdef robState < handle
    %ROBSTATE Update robot state based on encoders.
    
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
        hfig; hplot
        plot_flag
        first_time
    end
    
    methods
        function obj = robState(rob,mode,pose)
            %ROBSTATE Constructor.
            %
            % obj = ROBSTATE(rob,mode,pose)
            %
            % rob  - Real or simulated robot. Can be left empty in manual mode.
            % mode - 'robot' or 'manual'
            % pose - Length 3 array to start integration from.
            %
            % obj  - Instance.
            
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
            obj.hfig = figure; obj.hplot = plot(obj.pose(1),obj.pose(2),'.');
            axis equal; xlabel('x'); ylabel('y'); set(obj.hfig,'visible','off');
            obj.plot_flag = 0;
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
            vlEst = (obj.encoders.data.left-obj.left_enc_old)/1000/dt;
            vrEst = (obj.encoders.data.right-obj.right_enc_old)/1000/dt;
            % outlier check, since not using a filter
            if abs(vlEst) <= robotModel.VMax && abs(vrEst) <= robotModel.VMax
                obj.vl = vlEst; obj.vr = vrEst;
            end
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
        
        function togglePlot(obj)
            obj.plot_flag = ~obj.plot_flag;
            if obj.plot_flag && ishandle(obj.hfig)
                set(obj.hfig,'visible','on');
            elseif ~obj.plot_flag && ishandle(obj.hfig)
                set(obj.hfig,'visible','off');
            elseif obj.plot_flag && ~ishandle(obj.hfig)
                    obj.updatePlot();
            end
        end
        
        function updatePlot(obj)
            if ~obj.plot_flag
                return
            else
                if ishandle(obj.hfig)
                    set(obj.hplot,'XData',[get(obj.hplot,'XData') obj.pose(1)], ...
                        'YData',[get(obj.hplot,'YData') obj.pose(2)]);
                else
                    obj.hfig = figure; obj.hplot = plot(obj.pose(1),obj.pose(2),'.');
                    axis equal; xlabel('x'); ylabel('y');
                end
            end
        end
        
        function reset(obj,pose)
            %RESET Delete history and start over.
            %
            % RESET(obj,pose)
            %
            % pose - Optional. Length 3 array to start from. Defaults to
            %        [0;0;0].
            
            if strcmp(obj.mode,'robot')
                obj.listenerHandle.delete();
            end
            if nargin > 1
                obj.pose = pose;
            else
                obj.pose = [0;0;0];
			end
			if ishandle(obj.hfig)
				close(obj.hfig); 
			end
			obj.hfig = false; % a way to say it is not a handle anymore
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
             if isempty(evt.data.left)
                 % no data written to encoders yet
                return;
             end
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
         obj.updatePlot();
     end
    end
end
