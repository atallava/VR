classdef vaneSimulator < handle
	%vaneSimulator 
	
    properties
        laser
		elements
		nElements
    end
    
    methods
        function obj = vaneSimulator(laser)
            obj.laser = laser;
		end
		
		function setScene(obj,elements)
			obj.elements = elements;
			obj.nElements = length(elements);
		end
        
        function ranges = simulate(obj,pose)
            % pose is laser pose
            if isrow(pose) pose = pose'; end            
			ranges = zeros(1,obj.laser.nPixels);
            p0 = pose(1:2);
            for i = 1:obj.laser.nPixels
				th = obj.laser.bearings(i)+pose(3);
                r = [cos(th); sin(th)];
                tArray = zeros(1,obj.nElements);
                dArray = zeros(size(tArray));
                for j = 1:obj.nElements
                    elem = obj.elements(j);
                    [d,t] = mahalanobisDistanceRay(p0,r,elem.mu,elem.sigma);
                    tArray(j) = t;
                    dArray(j) = d;
                end
                elemIds = 1:obj.nElements;
                % discard negative rays
                flag = tArray < 0;
                tArray(flag) = []; dArray(flag) = []; elemIds(flag) = [];
                % discard rays that are far
                flag = dArray > sensorCarver.hitThreshold;
                tArray(flag) = []; dArray(flag) = []; elemIds(flag) = [];
                
                [tArray,sortedIds] = sort(tArray);
                dArray = dArray(sortedIds);
                elemIds = elemIds(sortedIds);
                
                noHit = true;
                for j = 1:length(tArray)
                    toss = rand;
                    if toss > obj.elements(elemIds(j)).perm
                        % sample from this element
                        elem = obj.elements(elemIds(j));
                        rayEnd = mvnrnd(elem.mu,elem.sigma);
                        if isrow(rayEnd) rayEnd = rayEnd'; end
                        ranges(i) = norm(rayEnd-pose(1:2));
                        noHit = false;
                        break;
                    else
                        continue;
                    end
                end
                if noHit
                    ranges(i) = obj.laser.nullReading;
                end
            end
        end
    end
    
end

