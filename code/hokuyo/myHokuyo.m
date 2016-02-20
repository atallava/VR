classdef myHokuyo < handle
    % dirty publisher of hokuyo's data
    
    properties
        laser
        bearings
        nBearings
        timerObj
        laserFreq = 0.5; %Hz
        ranges
    end
    
    events
        laserEvent
    end
    
    methods
        function obj = myHokuyo(laser)
            warning('off');
            obj.laser = laser;
            
            obj.bearings = deg2rad(linspace(-120,120,682)); 
            obj.nBearings = length(obj.bearings);
			
			obj.timerObj = timer;
			obj.timerObj.Tag = 'myHokuyo';
			obj.timerObj.ExecutionMode = 'fixedRate';
			%obj.timerObj.BusyMode = 'queue';
			obj.timerObj.Period = 1/obj.laserFreq;
			obj.timerObj.TimerFcn = @obj.readScan;
			start(obj.timerObj);
        end
        
        function readScan(obj,src,evt)
            obj.ranges = LidarScan(obj.laser);
			obj.ranges = 1e-3*obj.ranges; % convert to m
            notify(obj,'laserEvent',callbackData(obj.ranges));
        end
        
        function shutdown(obj)
           stop(obj.timerObj);
           delete(obj.timerObj);
        end
    end
    
end

