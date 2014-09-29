classdef registrationFilter < handle
    % for the laser registration
    
    properties
        choice
        R; Q
        poseArray; SArray
        scanArray; tArray
        refinerParams
    end
    
    methods
        function obj = registrationFilter(choice)
            obj.choice = choice;
            if strcmp(obj.choice,'real')
                load('real_registration_noise');
            elseif strcmp(obj.choice,'sim')
                load('sim_registration_noise');
            elseif strcmp(obj.choice,'baseline')
                load('baseline_registration_noise');
            else
                error('INVALID CHOICE.');
            end
            obj.R = R;
            obj.Q = Q;
            obj.refinerParams.skip = 5;
            obj.refinerParams.numIterations = 100;
        end
        
        function filter(obj,pose0,S0,scanArray,tArray,map)
            localizer = lineMapLocalizer(map.objects);
            refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser, ...
                'skip',obj.refinerParams.skip,'numIterations',obj.refinerParams.numIterations));
            
            
            obj.scanArray = scanArray;
            obj.tArray = tArray;
            obj.poseArray = zeros(3,length(obj.tArray)+1);
            obj.poseArray(:,1) = pose0;
            obj.SArray = cell(1,length(obj.tArray)+1);
            obj.SArray{1} = S0;
            V = 0; w = 0;
            
            for i = 1:length(tArray)
                if i == 1
                    dt = tArray(1);
                else
                    dt = tArray(i)-tArray(i-1);
                end
                
                % Motion
                th = obj.poseArray(3,i);
                obj.poseArray(1,i+1) = obj.poseArray(1,i)+V*cos(th)*dt;
                obj.poseArray(2,i+1) = obj.poseArray(2,i)+V*sin(th)*dt;
                obj.poseArray(3,i+1) = obj.poseArray(3,i)+w*dt;
                
                G = [1 0 -V*sin(th)*dt; ...
                    0 1 V*cos(th)*dt; ...
                    0 0 1];
                obj.SArray{i+1} = G*obj.SArray{i}*G'+obj.R;
                
                K = obj.SArray{i+1}/(obj.SArray{i+1}+obj.Q);
                
                [~,pEst] = refiner.refine(obj.scanArray{i},obj.poseArray(:,i+1));
                obj.poseArray(:,i+1) = obj.poseArray(:,i+1)+K*(pEst-obj.poseArray(:,i+1));
                
                obj.SArray{i+1} = (eye(3)-K)*obj.SArray{i+1};
                [V,w] = velocityFromPoses(obj.poseArray(:,i),obj.poseArray(:,i+1),dt);
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

