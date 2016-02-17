function [vehicleStateLog,tLog] = executeTracker(desiredPathSegments,vehicleStartState,simParams,pathTrackerParams)
    duration = 200;
    simSteps = ceil(duration/simParams.updatePeriod)+1;
    controlScale = 5;
        
    % init 
    vehicleState = vehicleStartState;
    commandCurvature = 1/1e6;
    commandSpeed = 0.0;
    controlCount = 1;
    
    % update logs first time
    logCount = 1;
    vehicleStateLog(logCount) = vehicleState;
    tLog(logCount) = 0;
    logCount = logCount+1;
    
    for i = 1:simSteps
        % update controls
        if mod(controlCount,controlScale) == 0
            [desiredRadius,desiredSpeed] = computeControls(desiredPathSegments,vehicleState,pathTrackerParams);
            
            if desiredSpeed == 0
                fprintf('End of tracking.\n');
                break;
            end
            
            commandCurvature = 1.0/desiredRadius;
            commandSpeed = desiredSpeed;
            
            controlCount = 0;
        end
        vehicleState = flatSim(vehicleState,commandSpeed,commandCurvature,simParams);
        controlCount = controlCount+1;
        
        % update logs
        vehicleStateLog(logCount) = vehicleState;
        tLog(logCount) = (i-1)*simParams.updatePeriod;
        logCount = logCount+1;
    end
end