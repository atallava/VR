classdef motionFilter < handle
    % only a motion model
        
    properties
        choice
        RLinear; RAngular; Rpd
        vlArray; vrArray; tArray
        poseArray; SArray        
        magicFactor = 0.01;
    end
    
    methods
        function obj = motionFilter(choice)
            obj.choice = choice;
            if strcmp(choice,'command')
                load('command_motion_noise');
            else
                load('enc_motion_noise');
            end
            obj.RLinear = RLinear;
            obj.RAngular = RAngular;
            obj.Rpd = Rpd;
        end
        
        function filter(obj,pose0,S0,vlArray,vrArray,tArray)
            %FILTER
            %
            % FILTER(obj,pose0,S0,vlArray,vrArray,tArray)

            obj.vlArray = vlArray;
            obj.vrArray = vrArray;
            obj.tArray = tArray;
            obj.poseArray = zeros(3,length(obj.tArray)+1);
            obj.poseArray(:,1) = pose0;
            obj.SArray = cell(1,length(obj.tArray)+1);
            obj.SArray{1} = S0;
            
            for i = 1:length(obj.tArray)
                if i == 1
                    dt = tArray(1);
                else
                    dt = tArray(i)-tArray(i-1);
                end
                [V,w] = robotModel.vlvr2Vw(vlArray(i),vrArray(i));
                th = obj.poseArray(3,i);
                obj.poseArray(1,i+1) = obj.poseArray(1,i)+V*cos(th)*dt;
                obj.poseArray(2,i+1) = obj.poseArray(2,i)+V*sin(th)*dt;
                obj.poseArray(3,i+1) = obj.poseArray(3,i)+w*dt;
                
                R = obj.RLinear*dt*abs(V)+obj.RAngular*dt*abs(w)+obj.Rpd; 
                R = R*obj.magicFactor;
                
                G = [1 0 -V*sin(th)*dt; ...
                    0 1 V*cos(th)*dt; ...
                    0 0 1];
                obj.SArray{i+1} = G*obj.SArray{i}*G'+R;
            end
        end
        
        function [poseArray,tArray] = sampleTrajectory(obj)
            poseArray = zeros(size(obj.poseArray));
            tArray = [0 obj.tArray];
            poseArray(:,1) = mvnrnd(obj.poseArray(:,1),obj.SArray{1})';
                        
            for i = 1:length(obj.tArray)
                if i == 1
                    dt = obj.tArray(1);
                else
                    dt = obj.tArray(i)-obj.tArray(i-1);
                end
                [V,w] = robotModel.vlvr2Vw(obj.vlArray(i),obj.vrArray(i));
                th = poseArray(3,i);
                poseArray(1,i+1) = poseArray(1,i)+V*cos(th)*dt;
                poseArray(2,i+1) = poseArray(2,i)+V*sin(th)*dt;
                poseArray(3,i+1) = poseArray(3,i)+w*dt;
                
                R = obj.RLinear*dt*abs(V)+obj.RAngular*dt*abs(w)+obj.Rpd;
                R = R*obj.magicFactor;
                
                eps = mvnrnd(zeros(3,1),R)';
                poseArray(:,i+1) = poseArray(:,i+1)+eps;
            end
        end
        
        function hf = plot(obj,map)
            if nargin < 2
                hf = figure;
            else
                hf = map.plot; 
            end
            hold on;
            plot(obj.poseArray(1,:),obj.poseArray(2,:),'r--');
            for i = 1:length(obj.SArray)
                if ~mod(i-1,100)
                    [x,y] = obj.getEllipsePoints(obj.SArray{i});
                    plot(x+obj.poseArray(1,i),y+obj.poseArray(2,i),'g--');
                end
            end
            hold off;
            axis equal;
            xlabel('x'); ylabel('y');
        end
        
        function [x,y] = getEllipsePoints(obj,S)
            S = S(1:2,1:2);
            conf = 0.5;
            [x,y,~] = errorEllipseGetPoints(S);
            k = qchisq(conf,2);
            x = k*x; y = k*y;
        end
    end
    
end

