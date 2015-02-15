classdef vaneSimulator < handle
        
    properties
        scRep
    end
    
    methods
        function obj = vaneSimulator(scRep)
            obj.scRep = scRep;
        end
        
        function ranges = simulate(obj,pose)
            % pose is laser pose
            if isrow(pose) pose = pose'; end            
            laser = obj.scRep.laser;
            ranges = zeros(1,laser.nPixels);
            p0 = pose(1:2);
            for i = 1:laser.nPixels
                th = laser.bearings(i);
                r = [cos(th); sin(th)];
                tArray = zeros(1,obj.scRep.gridCarving.nElements);
                dArray = zeros(size(tArray));
                for j = 1:obj.scRep.gridCarving.nElements
                    elem = obj.scRep.gridCarving.elements(j);
                    [d,t] = mahalanobisDistanceRay(p0,r,elem.mu,elem.sigma);
                    tArray(j) = t;
                    dArray(j) = d;
                end
                elemIds = 1:obj.scRep.gridCarving.nElements;
                % discard negative rays
                flag = tArray < 0;
                tArray(flag) = []; dArray(flag) = []; elemIds(flag) = [];
                % discard rays that are far
                flag = dArray > obj.scRep.hitThreshold;
                tArray(flag) = []; dArray(flag) = []; elemIds(flag) = [];
                
                [tArray,sortedIds] = sort(tArray);
                dArray = dArray(sortedIds);
                elemIds = elemIds(sortedIds);
                
                noHit = true;
                for j = 1:length(tArray)
                    toss = rand;
                    if toss > obj.scRep.permArray(elemIds(j))
                        % sample from this element
                        elem = obj.scRep.gridCarving.elements(elemIds(j));
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
                    ranges(i) = laser.nullReading;
                end
            end
        end
    end
    
end

