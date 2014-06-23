classdef robotTrajectory < handle
    %robotTrajectory

    properties (SetAccess = private)
        initPose
        initDist
        numSamples
        refControl
        tArray
        poseArray
        distArray
    end

    methods
        function obj = robotTrajectory(inputData)
            % inputData fields ('initPose','initDist','numSamples','refControl')
            % default ([0;0;0],0,1000,)
            if isfield(inputData,'initPose')
                obj.initPose = inputData.initPose;
            else
                obj.initPose = [0;0;0];
            end
            if isfield(inputData,'initDist')
                obj.initDist = inputData.initDist;
            else
                obj.initDist = 0;
            end
            if isfield(inputData,'numSamples')
                obj.numSamples = inputData.numSamples;
            else
                obj.numSamples = 1000;
            end
            if isfield(inputData,'refControl')
                obj.refControl = inputData.refControl;
            else
                error('REFERENCE CONTROL NOT INPUT');
            end
            
            obj.fillArrays();
        end
        
        function fillArrays(obj)
            obj.tArray = linspace(0,obj.refControl.getTrajectoryDuration,obj.numSamples+1);
            dt = obj.tArray(2)-obj.tArray(1);
            obj.poseArray = zeros(3,length(obj.tArray));
            obj.distArray = zeros(size(obj.tArray));
            obj.poseArray(:,1) = obj.initPose;
            obj.distArray(1) = obj.initDist;
            
            for i = 1:obj.numSamples
                [V,w] = obj.refControl.computeControl(obj.tArray(i));
                obj.poseArray(:,i+1) = robotModel.eulerIntegrate(obj.poseArray(:,i),V,w,dt);
                obj.distArray(i+1) = obj.distArray(i)+V*dt;
            end
        end
        
        function res = getPoseAtTime(obj,t)
            res = interp1(obj.tArray,obj.poseArray',t);
            res = res';
        end
        
        function [V,w] = getControl(obj,t)
            [V,w] = obj.refControl.computeControl(t);
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tArray(end);
        end
    end

    methods (Static = true)
    end

end
