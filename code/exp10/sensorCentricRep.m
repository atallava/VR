classdef sensorCentricRep < handle
    %sensorCentricRep

    properties %(SetAccess = private)
        obsArray; obsIds
        poses
        laser
        rayStart; rayEnd; rayDirn; nRays
        gridCarving
        hitArray; missArray; permArray;
        hitThreshold = 2;
    end
    
    methods
        function obj = sensorCentricRep(inputStruct)
            % inputStruct fields ('obsArray','obsIds','poses','laser')
            % default (,,,)
            if isfield(inputStruct,'obsArray')
                obj.obsArray = inputStruct.obsArray;
            else
            end
            if isfield(inputStruct,'obsIds')
                obj.obsIds = inputStruct.obsIds;
            else
            end
            if isfield(inputStruct,'poses')
                obj.poses = inputStruct.poses;
            else
            end
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
            end
                    
            obj.fillRays();
            obj.gridCarving = gridCarver(obj.rayEnd);
            obj.calcPermeabilities();
        end
        
        function fillRays(obj)
            [obj.rayStart,obj.rayEnd,obj.rayDirn] = deal([]);
            
            for i = 1:size(obj.poses,2)
                ranges = rangesFromObsArray(obj.obsArray,i,obj.obsIds);
                ri = rangeImage(struct('ranges',ranges,'bearings',obj.laser.bearings,'cleanup',1));
                pts = [ri.xArray; ri.yArray];
                pts = pose2D.transformPoints(pts,obj.poses(:,i));
                obj.rayEnd = [obj.rayEnd pts];
                p0 = repmat(obj.poses(1:2,i),1,size(pts,2));
                obj.rayStart = [obj.rayStart p0];
                r = pts-p0;
                rNorm = sqrt(sum(r.^2,1));
                r = bsxfun(@rdivide,r,rNorm);
                obj.rayDirn = [obj.rayDirn r];
            end
            obj.nRays = size(obj.rayStart,2);
        end
        
        function calcPermeabilities(obj)
            % to avoid singular matrix messages
            warning('off'); 
            [obj.hitArray,obj.missArray,obj.permArray] = deal(zeros(1,obj.gridCarving.nElements));
            % naive nested loop will slow things down
            t1 = tic();
            for i = 1:obj.nRays
                if ~mod(i,100)
                    fprintf('ray %d\n',i);
                end
                for j = 1:obj.gridCarving.nElements
                    elem = obj.gridCarving.elements(j);
                    d = mahalanobisDistance(obj.rayEnd(:,i),elem.mu,elem.sigma);
                    t = (obj.rayEnd(1,i)-obj.rayStart(1,i))/obj.rayDirn(1,i);
                    [dRay,tMin] = mahalanobisDistanceRay(obj.rayStart(:,i),obj.rayDirn(:,i),elem.mu,elem.sigma);
                    %fprintf('i: %d,j: %d\n',i,j);
                    %fprintf('d: %.2f, t: %.2f, dRay: %.2f, tMin: %.2f\n',d,t,dRay,tMin);
                    if d <= obj.hitThreshold
                        obj.hitArray(j) = obj.hitArray(j)+1;
                     %   fprintf('hit!\n');
                    elseif 0 <= tMin && tMin <= t && dRay <= obj.hitThreshold
                        obj.missArray(j) = obj.missArray(j)+1;
                      %  fprintf('miss!\n');
                    end
%                     waitforbuttonpress
                end
            end
            fprintf('Calculation took %.2fs\n',toc(t1));
            obj.permArray = obj.missArray./(obj.hitArray+obj.missArray);
            warning('on');
        end
        
    end

    methods (Static = true)
    end

end
