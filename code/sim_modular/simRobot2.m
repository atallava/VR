classdef simRobot2 < handle
    % Abhijeet's simRobot, built on Al's
	    
    properties(Constant)
        W  = robotModel.W;     % wheelTread in m
        W2 = robotModel.W*0.5;    % 1/2 wheelTread in m
        maxLogLen = 10000;              % max length of logging buffers
	end
    
    properties(Access = public)
        s = 0.0;
        pose = [0;0;0];
        V = 0.0; % linear velocity;
        w = 0.0; % angular velocity
        vl = 0.0;
        vr = 0.0;
        startTic = 0;
        lastTime = 0.0;
        doLogging = false;
        doDebug = false;
        tdelay = 0.0;
        realTimeMode = true;
		map;
		
		% modules
		inputModule;
		encodersModule;
		laserModule;
    end
    
    properties(Access = public)
        encoders = struct('data',struct('left',0,'right',0)); % wheel encoders
        logIndex = 1; % index of last logged data point in the arrays
        logArrayT  = zeros(1,simRobot.maxLogLen); % time log array
        logArrayS  = zeros(1,simRobot.maxLogLen); % (signed) distance log array
        logArrayX  = zeros(1,simRobot.maxLogLen); % x log array
        logArrayY  = zeros(1,simRobot.maxLogLen); % y log array
        logArrayTh = zeros(1,simRobot.maxLogLen); % heading log array
        logArrayV  = zeros(1,simRobot.maxLogLen); % linear velocity cmd log array
        logArrayW  = zeros(1,simRobot.maxLogLen); % angular velocity command log array
    end
    
    methods(Static = true)
        
    end
    
    methods(Access = public)
		function logData(obj)
        % Store data in the logging buffers until they are full.
            if(obj.doLogging == false)
                return;
            end
            if(obj.logIndex > 10000)
                fprintf('SimRobot: Logarray Length Exceeded. Logging stopped. \n');
                obj.logIndex = 10000;
            end         
            obj.logArrayT(obj.logIndex)  = obj.lastTime;
            obj.logArrayS(obj.logIndex)  = obj.s;
            obj.logArrayX(obj.logIndex)  = obj.pose(1);
            obj.logArrayY(obj.logIndex)  = obj.pose(2);
            obj.logArrayTh(obj.logIndex) = obj.pose(3);
            obj.logArrayV(obj.logIndex)  = obj.V;
            obj.logArrayW(obj.logIndex)  = obj.w;
            obj.logIndex = obj.logIndex + 1;
            if(obj.doDebug == true)
                %fprintf('Logging t:%f V:%f\n',obj.lastTime,obj.V);
            end
        end   
                        
        function updateStateStep(obj,time)
			% Update state based only on the passage of supplied time step and
			% the active commanded velocities.
			dt = time - obj.lastTime;
			obj.lastTime = time;
			% update encoders
			obj.encodersModule.updateEncoderValues(obj.vl,obj.vr,dt,time);
			obj.encoders = obj.encodersModule.getEncoderValues(time);

			[obj.V,obj.w] = robotModel.vlvr2Vw(obj.vl,obj.vr);

			% update pose
			obj.pose(3) = obj.pose(3) + obj.w*dt;
			th = obj.pose(3);
			ds = obj.V * dt;
			obj.s = obj.s + ds;
			obj.pose(1) = obj.pose(1) + ds*cos(th);
            obj.pose(2) = obj.pose(2) + ds*sin(th);
			
			% current velocities
			[obj.vl,obj.vr] = obj.inputModule.getVelocitiesAtTime(time);
			% Log data
            obj.logData();
        end
        
		function checkRealTimeMode(obj,mode)
			% Panics if the wrong time is used in a public method. Its almost
			% cretainly not what they intended.
			if(obj.realTimeMode ~= mode)
				err = MException('simRobot:InvalidMode', ...
					'This Method Cannot be Used in this Mode');
				throw(err);
			end
		end
		
	end
            
    methods(Access = public)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Constructor and Related Methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = simRobot2(components)
        % Construct a simRobot. After construction you must then 
        % "fireUp" the robot RIGHT BEFORE you start using it in real time
        % so that the delay simulation works correctly.
		obj.pose = [0; 0; 0]';
		obj.encoders.data.left = 0;
		obj.encoders.data.right = 0;
		obj.vl = 0; obj.vr = 0;
		obj.doLogging = false;
		obj.inputModule = components.inputModule;
		obj.encodersModule = components.encodersModule;
		obj.laserModule = components.laserModule;
        end
        
        function fireUpForRealTime(obj)
        % Start the clock and put the robot in real time mode where
        % state updates will be tagged based on true elapsed time. Calls
        % fireUpForSuppliedTime() for the present time.
            obj.startTic = tic();
            time = toc(obj.startTic);
%             fireUpForSuppliedTime(obj, time);
			obj.inputModule.fireUp(time);
			obj.encodersModule.fireUp(time);
			obj.realTimeMode = true;
        end
        
        function fireUpForSuppliedTime(obj, time)
			obj.inputModule.fireUp(time);
			obj.realTimeMode = false;
			obj.logData();
		end
		
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Control and Estimation Methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sendVelocity(obj,vl,vr)
        % Send commands to the left and right wheels. Calls sendVelocityForSuppliedTime
        % for the present time.
            obj.checkRealTimeMode(true); % This is a real time function call
            thisTime = toc(obj.startTic);
			obj.inputModule.sendVelocity(vl,vr,thisTime);
		end
        
        function sendVelocityAtTime(obj,vl,vr,time)
        % Send commands to the left and right wheels. Note that the
        % commands are sent through a FIFO so these commands will actually
        % affect the prediction/estimation after the delay has elapsed. The
        % delay is effected in continuous time with linear interpolation of 
        % the command FIFO.
            obj.checkRealTimeMode(false); % This is a non-real time function call
            sendVelocityStep(obj,vl,vr,time);
        end
        
        function setDebug(obj)
        % Used to turn on debugging for this instance only. You can
        % insert code and test (obj.debug == true) to activate it.
            obj.doDebug = true;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Update State Methods
        %
        % The next three methods are used to update the state. Both 
        % updateState() and updateStateFromEncoders() call 
        % updateStateStep(0 and the latter will call the logger to log all 
        % the data.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        function updateState(obj)
        % Update state based only on the passage of real time.
            obj.checkRealTimeMode(true); % This is a real time function call
            time = toc(obj.startTic);  % get time difference
            obj.updateStateStep(time);
        end
        
        function updateStateAtTime(obj,time)
        % Update state based on a supplied time
            obj.checkRealTimeMode(false); % This is a non-real time function call
            obj.updateStateStep(time);
        end

        function updateStateFromEncodersAtTime(obj,newLeft,newRight,time)
        % Set wheel and body velocities based on encoders and supplied time
        % tag.
            obj.checkRealTimeMode(false); % This is a non-real time function call
            dt = time-obj.lastTime;
            oldLeft = obj.encoders.data.left;
            oldRight = obj.encoders.data.right;         
            obj.vl = (newLeft - oldLeft)/dt/1000.0;
            obj.vr = (newRight - oldRight)/dt/1000.0;
            obj.V = (obj.vr+obj.vl)/2.0;
            obj.w = (obj.vr-obj.vl)/obj.W;
            obj.updateStateStep(time);       
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Map Methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function setMap(obj,map)
			obj.map = map;
			obj.laserModule.setMap(map);
		end
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Access Methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function pose = getPose(obj)
        % Get the most recent computed pose.
            pose = obj.pose;
		end
        
        function time = getLastTime(obj)
        % Get the most recent computed time.
            time = obj.lastTime;
        end
        
        function dist = getDistance(obj)
        % Get the most recent computed distance.
            dist = obj.s;
		end
		
		function data = getEncoderData(obj)
			data = obj.encoders.data;
		end
		
		function ranges = getLaserReadings(obj)
			ranges = obj.laserModule.getReadings(obj.pose);
		end
		
		function tCompStruct = getCompTime(obj)
			% Aggregation of module times.
			% Ignores own time.
			tCompStruct = struct();
			moduleNames = {'input','encoders','laser'};
			for i = 1:length(moduleNames)
				moduleName = [moduleNames{i} 'Module'];
				module = obj.(moduleName);
				tComp = module.tComp;
				tCompStruct.(moduleName) = tComp;
			end
		end
	end
end