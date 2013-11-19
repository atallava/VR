classdef sensor < handle
    %a range sensor in a 2 dimensional world
    
    properties(GetAccess = private, SetAccess = private)
        world; %currently a static lineMap
        pose = [0; 0; 0]; %sensor location in absolute coordinates
        rangeHistory; %sliding FIFO queue of range returns
        poseHistory; %for bwd propogation
        tHistory; %time tag history
        tpHistory; %time at which pose updates are made
        num_returns = 5; %number of returns, evenly divided among 2pi
        range_update_id = 1; %which return to update
        retIDHistory; %sliding FIFO que of update id history, only makes sense in case of high frequency updates
        range_update_type = 1;
        sensor_status = 0; %on or off
        sensor_range = 4.5;
        clock;
        sensor_delay = 0.1;
        range_update_timer;
        fs = 5; %frequency of sensing in Hz
        que_length = 10;
    end
    
    methods(Access = public)
     
        function obj = sensor(world,pose,n_returns,fs,update_type)
            obj.clock = tic;
            if(nargin > 1)
                obj.pose = pose; %starting pose
            end
            if(nargin > 2) %all sensor info
                obj.num_returns = n_returns;
                obj.fs = fs;
                obj.range_update_type = update_type;
            end            
            obj.world = world;    
            obj.rangeHistory = slidingFifoQueue(obj.que_length,obj.num_returns);
            obj.tHistory = slidingFifoQueue(obj.que_length);            
            if obj.range_update_type == 3
                obj.tpHistory = slidingFifoQueue(10*obj.que_length); 
                %hack to ensure enough high-frequency pose history 
                %basically reaching the point where pose updating must be
                %included within the class
                obj.poseHistory = slidingFifoQueue(10*obj.que_length,3);
            end
        end
        
        function obj = startSensor(obj)
            obj.range_update_timer = timer;
            obj.range_update_timer.BusyMode = 'queue';
            obj.range_update_timer.ExecutionMode = 'fixedRate';
            %obj.range_update_timer.TasksToExecute = 1;
            if obj.range_update_type == 1
                obj.range_update_timer.Period = 1/obj.fs; %one-shot update
            elseif obj.range_update_type == 2
                obj.retIDHistory = slidingFifoQueue(obj.que_length);
                obj.range_update_timer.Period = 1/(obj.num_returns*obj.fs); %high frequency updates
            elseif obj.range_update_type == 3
               obj.range_update_timer.Period = 1/obj.fs; %bwd propagation
            else
                err = MException('ResultChk:InvalidChoice','choice of range update must be in {1,3}');
                throw(err);
            end
            obj.range_update_timer.TimerFcn = @obj.updateRange;
            %should pause for sensor_delay time after starting sensor
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
           
            if obj.range_update_type == 3
                obj.poseHistory.add(pose'); %because sliding que wants rows
                obj.poseHistory.que;
                obj.tpHistory.add(toc(obj.clock));
            end
        end
        
        function val = getRange(obj)
            tnow = toc(obj.clock);
            %of course, if timer gets delayed in the execution queue, this
            %test fails
            if tnow <= (obj.sensor_delay + 1e-3)
                err = MException('sensor:InsufficientTime',fprintf('need to wait for %f time before getting data',obj.sensor_delay));
                throw(err);
            end
            id = find(obj.tHistory.que <= tnow - obj.sensor_delay);
            if obj.range_update_type == 1 || obj.range_update_type == 3
                val = obj.rangeHistory.que(id(end),:);
            else
                %range data is returned as a package only when a full turn
                %is made
                id2 = find(obj.retIDHistory.que(id) == obj.num_returns);
                val = obj.rangeHistory.que(id(id2(end)),:);            
            end
        end
        
        function val = getPose(obj)
            val = obj.pose;
        end
        
        function updateRange(obj,caller,event)
            obj.tHistory.add(toc(obj.clock));    
            dtheta = 360.0/obj.num_returns;
            angles = 0:1:(obj.num_returns-1); angles = angles*dtheta;
        
            if obj.range_update_type == 1
                %update all returns at same time            
                obj.rangeHistory.add(obj.world.raycast(obj.pose,obj.sensor_range,angles));
            
            elseif obj.range_update_type == 2
                %high frequency
                %need to be careful that the length of sliding queue is
                %enough to query last set of updates
                obj.retIDHistory.add(obj.range_update_id);
                theta = dtheta*(obj.range_update_id-1);
                if isempty(obj.rangeHistory.que)
                    range = zeros(1,obj.num_returns);
                else
                    range = obj.rangeHistory.que(end,:); %most recent range update
                end
                range(obj.range_update_id) = obj.world.raycast(obj.pose,obj.sensor_range,theta);
                obj.rangeHistory.add(range);
                obj.range_update_id = mod(obj.range_update_id+1,obj.num_returns);
                if obj.range_update_id == 0
                    obj.range_update_id = obj.num_returns; 
                end
                
            elseif obj.range_update_type == 3
                %bwd propagation
                %will suffer from inaccuracies due to inexact pose ...
                %information
                times = arrayfun(@(x) obj.tHistory.que(end)-x/(obj.num_returns*obj.fs),1:obj.num_returns);
                x = interp1(obj.tpHistory.que,obj.poseHistory.que(:,1),times);
                y = interp1(obj.tpHistory.que,obj.poseHistory.que(:,2),times);
                th = interp1(obj.tpHistory.que,obj.poseHistory.que(:,3),times);
                poses = [x;y;th];
                theta = arrayfun(@(x) x*dtheta, obj.num_returns-1:-1:0);
                %effectively sequential computation, will be very slow
                range = arrayfun(@(x) obj.world.raycast(poses(:,x),obj.sensor_range,theta(x)), 1:obj.num_returns);
                range = fliplr(range);
                obj.rangeHistory.add(range);
            end                
        end
    end
end