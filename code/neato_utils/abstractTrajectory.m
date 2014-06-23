classdef (Abstract) abstractTrajectory < handle
    %abstractTrajectory base class for trajectories
    
    properties
        tIdle = 0.5;
    end
    
    methods (Abstract)
        res = getTrajectoryDuration(obj)
        res = getPoseAtTime(obj,t)
        [V,w] = getControl(obj,t)
    end
    
end

