classdef cubicSpiral < handle & abstractTrajectory
    
    properties (SetAccess = private)
        params
        nIntervals
        startPose; finalPose
        sArray; kArray
        poseArray
        VArray; wArray
        tArray
        poseCheck
        flag
        energy
    end
    
    methods
        function obj = cubicSpiral(inputData)
            % inputData fields ('params','nIntervals','startPose','poseCheck')
            % params is of form [a,b,sf]
            % default (,1000,[0;0;0],[])
            obj.params = inputData.params;
            if isfield(inputData,'nIntervals')
                obj.nIntervals = inputData.nIntervals;
            else
                obj.nIntervals = 5000;
            end
            if ~isfield(inputData,'startPose')
                obj.startPose = [0;0;0];
            else
                obj.startPose = inputData.startPose;
            end
            if ~isfield(inputData,'poseCheck')
                obj.poseCheck = [];
            else
                obj.poseCheck = inputData.poseCheck;
            end
            obj.flag = obj.computePath;
            if ~obj.flag
                warning('FAILED POSECHECK WHILE COMPUTING PATH.');
            end
            %obj.planVelocities(robotModel.VMax);
%             obj.planVelocitiesMaxVel(5);
            obj.planVelocitiesSmoothVel([5 5]);
        end
        
        function success = computePath(obj)
            success = true;
            obj.sArray = linspace(0,obj.params(3),obj.nIntervals+1);
            ds = obj.sArray(2)-obj.sArray(1);
            obj.kArray = arrayfun(@(s) cubicSpiral.kValue(s,obj.params), obj.sArray);
            obj.poseArray = zeros(3,length(obj.sArray));
            obj.poseArray(:,1) = obj.startPose;
            for i = 1:obj.nIntervals
                th = obj.poseArray(3,i)+obj.kArray(i)*ds*0.5;
                obj.poseArray(1,i+1) = obj.poseArray(1,i)+cos(th)*ds;
                obj.poseArray(2,i+1) = obj.poseArray(2,i)+sin(th)*ds;
                obj.poseArray(3,i+1) = th+obj.kArray(i)*ds*0.5;
                if isempty(obj.poseCheck)
                    continue;
                end
                if ~obj.poseCheck(obj.poseArray(:,i+1))
                    success = false;
                    break
                end
            end
            obj.energy = sum(obj.kArray.^2)*ds;
            obj.finalPose = obj.poseArray(:,end);
        end
        
        function planVelocitiesMaxVel(obj,Vmax)
            obj.tArray = zeros(size(obj.kArray));
                        
            for i = 1:length(obj.kArray)
                V = Vmax;
                w = V*obj.kArray(i);

                [vl,vr] = robotModel.Vw2vlvr(V,w);
                
                temp = max(abs([vl,vr]));
                if temp > Vmax
                    scale = (Vmax-0.01)/temp;
                    vr = scale*vr; vl = scale*vl;
                end
                [V,w] = robotModel.vlvr2Vw(vl,vr);
                obj.VArray(i) = V;
                obj.wArray(i) = w;
                if i > 1
                    obj.tArray(i) = obj.tArray(i-1)+(obj.sArray(i)-obj.sArray(i-1))/obj.VArray(i-1);
                end
            end
        end
        
        function planVelocitiesSmoothVel(obj,VLims)
            
            obj.VArray = randomSmoothFn(1:length(obj.kArray),VLims);
            obj.wArray = obj.VArray.*obj.kArray;
            dtArray = diff(obj.sArray)./obj.VArray(1:end-1);
            obj.tArray = [0 cumsum(dtArray)];
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tArray(end)+2*obj.tIdle;
        end
        
        function res = getPoseAtTime(obj,t)
            if t < obj.tIdle
                res = obj.startPose;
            elseif t > obj.tArray(end)+obj.tIdle
                res = obj.finalPose;
            else
                t = t-obj.tIdle;
                res = interp1(obj.tArray,obj.poseArray',t);
                res = res';
            end
        end
        
        function [V,w] = getControl(obj,t)
            if t < obj.tIdle
                V = 0; w = 0;
            elseif t > obj.tArray(end)+obj.tIdle
                V = 0; w = 0;
            else
                t = t-obj.tIdle;
                V = interp1(obj.tArray,obj.VArray,t);
                w = interp1(obj.tArray,obj.wArray,t);
            end
        end
        
        function hf = plot(obj)
            hf = figure;
            plot(obj.poseArray(1,:),obj.poseArray(2,:));
            axis equal; xlabel('x'); ylabel('y');
        end
        
        function saveWaypoints(obj,fname)
            %SAVEWAYPOINTS Write timestamped poses to file.
            %
            % SAVEWAYPOINTS(obj,fname)
            %
            % fname - File to save to. Extension .txt by default.
            
            if isempty(strfind(fname,'.'))
                fname = [fname '.txt'];
            end
            fout = fopen(fname,'w');
            for i = 1:length(obj.tArray)
                fprintf(fout,'%.6f %.6f %.6f %.6f\n',obj.tArray(i),obj.poseArray(1,i),obj.poseArray(2,i),...
                    obj.poseArray(3,i));
            end
            fclose(fout);
        end
    
    end
    
    methods (Static = true)
        function k = kValue(s,params)
            k = s*(params(1)+params(2)*s)*(s-params(3));
        end
    end
    
end

