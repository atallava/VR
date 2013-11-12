classdef sensor < handle
    %a range sensor in a 2 dimensional world
    
    properties(GetAccess = private, SetAccess = private)
        world; %currently a static lineMap
        pose = [0 0 0]; %sensor location in absolute coordinates
        range; %range returns
        num_returns = 4; %number of returns, evenly divided among 2pi
        range_update_id = 1; %which return to update
        range_update_type;
        sensor_status = 0; %on or off
        motion_status = 0;
        sensor_range = 4.5;
        range_update_timer;
        fs = 5; %frequency of sensing in Hz
    end
    
    methods(Access = public)
        function obj = sensor(world,pose,n_returns,fs)
            if(nargin > 1)
                obj.pose = pose; %starting pose
            end
            if(nargin > 2) %all sensor info
                obj.num_returns = n_returns;
                obj.fs = fs;
            end            
            obj.world = world;
            obj.range = zeros(1,obj.num_returns);
        end
        function obj = startSensor(obj,choice)
            obj.range_update_type = choice;
            obj.range_update_timer = timer;
            obj.range_update_timer.BusyMode = 'queue';
            obj.range_update_timer.ExecutionMode = 'fixedRate';
            if choice == 1
                obj.range_update_timer.Period = 1/obj.fs; %prediction-correction                
            elseif choice == 2
                obj.range_update_timer.Period = 1/(obj.num_returns*obj.fs); %high frequency updates
            elseif choice == 3
                obj.range_update_timer.Period = 1/obj.fs; %prediction-correction
            else
                err = MException('ResultChk:InvalidChoice','choice of range update must be in {1,2}');
                throw(err);
            end
            obj.range_update_timer.TimerFcn = @obj.updateRange;
            start(obj.range_update_timer); 
            obj.sensor_status = 1;
        end
        function obj = stopSensor(obj)
           stop(obj.range_update_timer);
           delete(obj.range_update_timer);
           obj.sensor_status = 0;
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
            if obj.range_update_type == 1
                theta = 360.0/obj.num_returns;
                angles = 0:1:(obj.num_returns-1); angles = angles*theta;
                obj.range = obj.world.raycast(obj.pose,obj.sensor_range,angles);
            elseif obj.range_update_type == 2
                %high frequency
                theta = (360.0/obj.num_returns)*(obj.range_update_id-1);
                obj.range(obj.range_update_id) = obj.world.raycast(obj.pose,obj.sensor_range,theta);
                obj.range_update_id = mod(obj.range_update_id+1,obj.num_returns);
                if obj.range_update_id == 0
                    obj.range_update_id = obj.num_returns;
                end
            elseif obj.range_update_type == 3
                %prediction-correction
                %something
            end
        end
    end
end
