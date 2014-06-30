classdef playbackTool < handle
    %playbackTool
    % Usage: first create listeners, then play. shutdown at end
    
    properties (Constant = true)
        freq = 100;
        tEps = 0.005;
    end
    
    properties (SetAccess = public)
        ticRef; tLocal; tMax
        tLocalLog;
        tPauseStart; tPauseEnd;
        playFlag; startedFlag; endedFlag; shutdownFlag
        tEncArray; encArray
        tLaserArray; laserArray
        encPub; laserPub
        timerObj
    end
    
    methods
        function obj = playbackTool(tEncArray,encArray,tLaserArray,laserArray)
            % encArray is a struct array with fields 'left', 'right
            % laserArray is a struct array with fields 'ranges'
            obj.tLocal = 0; obj.tLocalLog = [];
            obj.tEncArray = tEncArray; obj.encArray = encArray; 
            obj.tLaserArray = tLaserArray; obj.laserArray = laserArray;
            
            obj.tMax = max([tEncArray tLaserArray]);
            obj.tPauseStart = 0; obj.tPauseEnd = 0;
            obj.playFlag = 0; obj.startedFlag = 0; obj.endedFlag = 0; obj.shutdownFlag = 0;
                        
            obj.encPub = encoderPublisher();
            obj.laserPub = laserPublisher(robotModel.laser);
            
            obj.timerObj = timer;
            obj.timerObj.Tag = 'playbackTool'; 
            obj.timerObj.ExecutionMode = 'fixedRate';
            obj.timerObj.BusyMode = 'queue';
            obj.timerObj.Period = 1/playbackTool.freq;
            obj.timerObj.TimerFcn = @obj.timerUpdate;
        end
        
        
        function listenerObj = createEncListener(obj)
            listenerObj = sensorListener(obj.encPub);
            obj.encPub.setData(obj.encArray(1));
            obj.encPub.publish();
        end
        
        function listenerObj = createLaserListener(obj)
            listenerObj = sensorListener(obj.laserPub);
            obj.laserPub.setData(obj.laserArray(1));
            obj.laserPub.publish();
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
                obj.tLocal = t;
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
                obj.tLocal = toc(obj.ticRef)-(obj.tPauseEnd-obj.tPauseStart);
                obj.tLocalLog(end+1) = obj.tLocal;
                if obj.tLocal > obj.tMax+playbackTool.tEps;
                    obj.playFlag = 0;
                    obj.endedFlag = 1;
                else
                    % find and publish encoder data
                    flag1 = obj.tEncArray >= obj.tLocal-playbackTool.tEps;
                    flag2 = obj.tEncArray <= obj.tLocal+playbackTool.tEps;
                    encData = obj.encArray(flag1 & flag2);
                    if ~isempty(encData)
                        if length(encData) > 1
                            warning('FOUND MORE THAN ONE MATCH FOR ENCODER DATA. REDUCE PLAYBACKPUBLISHER.TEPS\n');
                        end
                        encData = encData(1);
                        obj.encPub.setData(encData);
                        obj.encPub.publish();
                    end
                    
                    % find and publish laser data
                    flag1 = obj.tLaserArray >= obj.tLocal-playbackTool.tEps;
                    flag2 = obj.tLaserArray <= obj.tLocal+playbackTool.tEps;
                    laserData = obj.laserArray(flag1 & flag2);
                    if ~isempty(laserData)
                        if length(laserData) > 1
                            warning('FOUND MORE THAN ONE MATCH FOR LASER DATA. REDUCE PLAYBACKPUBLISHER.TEPS\n');
                        end
                        laserData = laserData(1);
                        obj.laserPub.setData(laserData);
                        obj.laserPub.publish();
                    end
                end
            end
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

