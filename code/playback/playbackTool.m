classdef playbackTool < handle
    %playbackTool
    
    properties (Constant = true)
        freq = 100;
        tEps = 0.5/playbackTool.freq;
    end
    
    properties (SetAccess = public)
        ticRef; tLocal; tMax; tRef = 0;
        tLocalLog;
        tPauseStart; tPauseEnd;
        playFlag; startedFlag; endedFlag; shutdownFlag
        tEncArray; encArray
        tLaserArray; laserArray
        encCount; laserCount;
        encoders; laser
        timerObj
    end
    
    methods
        function obj = playbackTool(inputStruct)
            %PLAYBACKTOOL Constructor.
            %
            % obj = PLAYBACKTOOL(inputStruct)
            %
            % inputStruct fields:
            % tEncArray   - Vector of encoder timestamps. 
            % encArray    - struct array with fields 'left', 'right'.
            % tLaserArray - Vector of laser timestamps. Has to have the
            %               same frame as tEncArray.
            % laserArray  - struct array with fields 'ranges'.
            %
            % obj         - Instance.
            
            if isfield(inputStruct,'tEncArray')
                obj.tEncArray = inputStruct.tEncArray;
            else
                error('TENCARRAY NOT INPUT.');
            end
            if isfield(inputStruct,'encArray')
                obj.encArray = inputStruct.encArray;
            else
                error('ENCARRAY NOT INPUT.');
            end
            if isfield(inputStruct,'tLaserArray')
                obj.tLaserArray = inputStruct.tLaserArray;
            else
                error('TLASERARRAY NOT INPUT.');
            end
            if isfield(inputStruct,'laserArray')
                obj.laserArray = inputStruct.laserArray;
            else
                error('LASERARRAY NOT INPUT.');
            end
            
            obj.tLocal = 0; obj.tLocalLog = [];
            obj.encCount = 1; obj.laserCount = 1;
            
            obj.tMax = max([obj.tEncArray obj.tLaserArray]);
            obj.tPauseStart = 0; obj.tPauseEnd = 0;
            obj.playFlag = 0; obj.startedFlag = 0; obj.endedFlag = 0; obj.shutdownFlag = 0;
                        
            obj.encoders = encoderPublisher(); 
            obj.encoders.setData(obj.encArray(1));
            obj.laser = laserPublisher(robotModel.laser);
            obj.laser.setData(obj.laserArray(1));
            
            obj.timerObj = timer;
            obj.timerObj.Tag = 'playbackTool'; 
            obj.timerObj.ExecutionMode = 'fixedRate';
            obj.timerObj.BusyMode = 'queue';
            obj.timerObj.Period = 1/playbackTool.freq;
            obj.timerObj.TimerFcn = @obj.timerUpdate;
        end
        
        
        function listenerObj = createEncListener(obj)
            listenerObj = sensorListener(obj.encoders);
            obj.encoders.setData(obj.encArray(1));
            obj.encoders.publish();
        end
        
        function listenerObj = createLaserListener(obj)
            listenerObj = sensorListener(obj.laser);
            obj.laser.setData(obj.laserArray(1));
            obj.laser.publish();
        end
        
        function play(obj)
            % constraints on state of variables forces structure on
            % code
            if obj.startedFlag && ~obj.playFlag
                obj.tPauseEnd = toc(obj.ticRef);
            end
            obj.playFlag = 1;
            if ~obj.startedFlag
                obj.startedFlag = 1;
                obj.ticRef = tic;
                start(obj.timerObj);               
            end
        end
        
        function setLocalTime(obj,t)
            if obj.playFlag
                fprintf('PAUSE TIMER BEFORE ATTEMPTING TO SET LOCAL TIME.\n');
            else
                obj.tRef = t;
            end
        end
        
        function pause(obj)
            if obj.playFlag
                obj.tPauseStart = toc(obj.ticRef);
            end
            obj.playFlag = 0;
        end
        
        function timerUpdate(obj,src,evt)
            if obj.playFlag
                obj.tLocal = toc(obj.ticRef)-(obj.tPauseEnd-obj.tPauseStart)+obj.tRef;
                
                % publish encoder data
                if obj.encCount <= length(obj.encArray)
                    if obj.tLocal > obj.tEncArray(obj.encCount)
                        encData = obj.encArray(obj.encCount);
                        encData.header.stamp = obj.timestamp();
                        obj.encoders.setData(encData);
                        obj.encoders.publish();
                        obj.encCount = obj.encCount+1;
                    end
                end
                
                % publish laser data
                if obj.laserCount <= length(obj.laserArray) 
                    if obj.tLocal > obj.tLaserArray(obj.laserCount)
                        laserData = obj.laserArray(obj.laserCount);
                        laserData.header.stamp = obj.timestamp();
                        obj.laser.setData(laserData);
                        obj.laser.publish();
                        obj.laserCount = obj.laserCount+1;
                    end
                end
                
                if obj.laserCount > length(obj.laserArray) && obj.encCount > length(obj.encArray)
                    obj.playFlag = 0;
                    obj.endedFlag = 1;
                end
            end
        end
        
        function stamp = timestamp(obj)
            stamp.secs = floor(obj.tLocal);
            stamp.nsecs = (obj.tLocal-stamp.secs)*1e9;
        end
                       
        function shutdown(obj)
            obj.shutdownFlag = 1;
            stop(obj.timerObj);
            delete(obj.timerObj);
        end
    end
    
    methods (Static = true)
        
    end
    
end

