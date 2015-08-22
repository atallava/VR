classdef multiReflect < handle
    % a model which considers two bounces from walls
    
    properties
        sensor
        map
        K = 2.5e-3;
        biasFactor = 0.02;
    end
    
    methods
        function obj = multiReflect(inputStruct)
            obj.sensor = inputStruct.sensor;
            obj.map = inputStruct.map;
        end
        
        function setMap(obj,map)
            obj.map = map;
        end
        
        function readings = simulate(obj,pose)
            % get bearings of sensor
            readings = zeros(1,obj.sensor.nBearings);
            % get ranges for first two reflections. some could be nan
            [ranges1,alpha1] = obj.map.raycast(pose,obj.sensor.maxRange,obj.sensor.bearings);
            ranges2 = zeros(size(ranges1));
            
            posesReflect = zeros(3,obj.sensor.nBearings);
            posesReflect(1,:) = pose(1)+ranges1.*cos(pose(3)+obj.sensor.bearings);
            posesReflect(2,:) = pose(2)+ranges1.*sin(pose(3)+obj.sensor.bearings);

            ray1Theta = pose(3)+obj.sensor.bearings;
            % this is going to be really slow
            for j = 1:length(ranges2)
                if (ranges1(j) == 0)
                    ranges2(j) = 0;
                    continue;
                end
                % pose at which to query next range
                alpha = alpha1(j);
                [l,r] = circArray.circNbrs(j,obj.sensor.nBearings,2);
                alphaPrev = alpha1(l);
                alphaNext = alpha1(r);
                surfaceType = obj.getSurfaceType(alphaPrev,alpha,alphaNext);
                if surfaceType == 1
                    theta = -(pi-(ray1Theta(j)+2*alpha));
                else
                    theta = ray1Theta(j)+pi-2*alpha;
                end
                posesReflect(3,j) = theta;
                
                % move a bit along theta
                posesReflect(1:2,j) = posesReflect(1:2,j) + 1e-4*[cos(theta); sin(theta)];
                [ranges2(j),~] = obj.map.raycast(posesReflect(:,j),obj.sensor.maxRange,0);
            end
            
            
            % sample form pdf for each bearing
            bias1 = obj.biasFactor*ranges1;
            sigma1 = obj.K*ranges1.^2;
            prob1 = (ranges1+ranges2)./(2*ranges1+ranges2);
            prob1(ranges2 == 0) = 1;
            bias2 = obj.biasFactor*(ranges1+ranges2);
            sigma2 = obj.K*(ranges1+ranges2).^2;
            for j = 1:length(ranges1)
                if ranges1(j) == 0
                    readings(j) = obj.sensor.nullReading;
                    continue;
                end
                if ranges2(j) == 0
                    readings(j) = ranges1(j)+bias1(j)+sigma1(j)*randn();
                    continue;
                end
                toss = rand();
                if toss < prob1(j)
                    readings(j) = ranges1(j)+bias1(j)+sigma1(j)*randn();
                else
                    if ranges1(j)+ranges2(j) > obj.sensor.maxRange
                        readings(j) = obj.sensor.nullReading;
                    else
                        readings(j) = (ranges1(j)+ranges2(j))+bias2(j)+sigma2(j)*randn();
                    end
                end
            end
        end
        
        function surfaceType = getSurfaceType(obj,alphaPrev,alpha,alphaNext)
            if alphaPrev > alphaNext
                surfaceType = 1;
            else
                surfaceType = 2;
            end
        end
    end
    
end

