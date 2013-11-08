classdef sensor < handle
    %a range sensor in a single dimensional world
    
    properties(GetAccess = private, SetAccess = private)
        world = 0; %object location in absolute coordinates
        pose = 0; %sensor location in absolute coordinates
        range = 0; %last recorded range measurement
        sensor_status = 0;
        motion_status = 0;
        t1;
        range_update_timer;
        pose_update_timer;
        motion_tic;
        fs = 5; %frequency of sensing in Hz
    end
    
    methods(Access = public)
        function obj = sensor(world,pose,fs)
            if(nargin > 2)
                obj.fs = fs;
            end            
            t1 = tic;
            obj.world = world;
            obj.pose = pose; %starting pose of robot                        
        end
        function obj = startSensor(obj)
            obj.range_update_timer = timer;
            obj.range_update_timer.BusyMode = 'queue';
            obj.range_update_timer.ExecutionMode = 'fixedRate';
            obj.range_update_timer.Period = 1/obj.fs;
            obj.range_update_timer.TimerFcn = @obj.updateRange;
            start(obj.range_update_timer); 
            obj.sensor_status = 1;
        end
        function obj = stopSensor(obj)
           stop(obj.range_update_timer);
           delete(obj.range_update_timer);
           obj.sensor_status = 0;
        end        
        function obj = startMotion(obj)
            obj.pose_update_timer = timer;
            obj.pose_update_timer.BusyMode = 'queue';
            obj.pose_update_timer.ExecutionMode = 'fixedRate';
            obj.pose_update_timer.Period = 1/obj.fs;
            obj.pose_update_timer.TimerFcn = @obj.updateRange;
            start(obj.pose_update_timer); 
            obj.sensor_status = 1;
        end
        function val = sensorStatus(obj)
            val = obj.sensor_status;
            end
        function obj = updatePose(obj,pose)
            obj.pose = pose;            
        end        
        function val = getRange(obj)            
            val = obj.range;
        end
        function val = getPose(obj)            
            val = obj.pose;
        end
        function updateRange(obj,caller,event)
            obj.range = obj.world-obj.pose;
        end
    end
end
