classdef sampleConfiguration < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        objectList = {};
        nLine1; nLine2; nLine3;
        boxLength; nCenters
        th;
        lineLength1 = 0.61;
        lineLength2 = 1.22;
        lineLength3 = 1.81;
        gridUnit = 0.35;
        nObjects;
        nPlaceAttempts = 20;
        map
        mask
        maskResn = 0.05;
        maskLim
    end
    
    methods
        function obj = sampleConfiguration()
            load objects
            obj.nLine1 = randperm(2,1);
            obj.nLine2 = randperm(2,1);
            obj.nLine3 = randperm(2,1)-1;
            obj.boxLength = worldBox(2,1);
            obj.nCenters = floor(obj.boxLength/obj.gridUnit);
            obj.th = [0 atan(0.5) pi/4 atan(2)];
            obj.th = [obj.th obj.th+pi/2 obj.th+pi obj.th+3*pi/2];
            obj.nObjects = 2;
            obj.objectList = {worldBox robotBox};
            obj.sampleWorld();
            obj.createMap();
            obj.maskLim = [-obj.maskResn obj.boxLength+obj.maskResn];
            obj.fillMask();
        end
        
        function sampleWorld(obj)
            for i = 1:obj.nLine1
                for j = 1:obj.nPlaceAttempts
                    [res,line] = obj.placeLine(obj.lineLength1);
                    if ~res
                        obj.nObjects = obj.nObjects+1;
                        obj.objectList{obj.nObjects} = line;
                        break;
                    end
                end
                if res
                    obj.nLine1 = obj.nLine1-1;
                end
            end
            
            for i = 1:obj.nLine2
                for j = 1:obj.nPlaceAttempts
                    [res,line] = obj.placeLine(obj.lineLength2);
                    if ~res
                        obj.nObjects = obj.nObjects+1;
                        obj.objectList{obj.nObjects} = line;
                        break;
                    end
                end
                if res
                    obj.nLine2 = obj.nLine2-1;
                end                
            end
            
            for i = 1:obj.nLine3
                for j = 1:obj.nPlaceAttempts
                    [res,line] = obj.placeLine(obj.lineLength3);
                    if ~res
                        obj.nObjects = obj.nObjects+1;
                        obj.objectList{obj.nObjects} = line;
                        break;
                    end
                end
                if res
                    obj.nLine3 = obj.nLine3-1;
                end                
            end
        end
        
        function [res,line] = placeLine(obj,lineLength)
            ix = randperm(obj.nCenters,1); 
            iy = randperm(obj.nCenters,1); 
            x = ix*obj.gridUnit;
            y = iy*obj.gridUnit;
            theta = datasample(obj.th,1);
            line = [0 0;lineLength*cos(theta) lineLength*sin(theta)];
            line = bsxfun(@plus,line,[x y]);
            res = obj.checkCollision(line);
        end
        
        function res = checkCollision(obj,line)
            res = false;
            for i = 1:length(obj.objectList);
                o = obj.objectList{i};
                [xi,yi] = polyxpoly(line(:,1),line(:,2),o(:,1),o(:,2));
                if ~isempty(xi)
                    res = true;
                    break;
                end
            end
        end
        
        function createMap(obj)
            for i = 1:obj.nObjects
                loArray(i) = lineObject();
                loArray(i).lines = obj.objectList{i};                
            end
            obj.map = lineMap(loArray);
        end
        
        function fillMask(obj)
            nCell = floor((obj.maskLim(2)-obj.maskLim(1))/obj.maskResn);
            obj.mask = zeros(nCell,nCell);
            for i = 1:obj.nObjects
                o = obj.objectList{i};
                for j = 1:(size(o,1)-1)
                    [r1,c1] = obj.getMaskIndices(o(j,:));
                    [r2,c2] = obj.getMaskIndices(o(j+1,:));
                    if c1 < c2
                        cs = c1; rs = r1;
                        ce = c2; re = r2;
                    else
                        cs = c2; rs = r2;
                        ce = c1; re = r1;
                    end
                    rSpan = abs(r1-r2); cSpan = abs(c1-c2);
                    span = min(rSpan,cSpan);
                    span = span+1;
                    r = rs; c = cs;
                    for k = 1:span
                        r = rs+sign(re-rs)*(k-1);
                        c = cs+k-1;
                    end
                    
                    if cSpan < rSpan
                        if re > r
                            obj.mask(r:re,c) = 1;
                        else
                            obj.mask(re:r,c) = 1;
                        end
                    else
                        obj.mask(r,c:ce) = 1;
                    end
                end
            end
        end
        
        function [r,c] = getMaskIndices(obj,posn)
            c = floor((posn(1)-obj.maskLim(1))/obj.maskResn)+1;
            r = floor((posn(2)-obj.maskLim(1))/obj.maskResn)+1;
            r = size(obj.mask,1)-r+1;
        end
        
        function hf = plot(obj)
            hf = figure; hold on; 
            for i = 1:obj.nObjects
                o = obj.objectList{i};
                plot(o(:,1),o(:,2),'b');
            end
            grid on;
            set(gca,'xtick',0:obj.gridUnit:obj.nCenters*obj.gridUnit);
            set(gca,'ytick',0:obj.gridUnit:obj.nCenters*obj.gridUnit);
            axis equal; hold off;
            xlabel('x');
            ylabel('y');
        end
    end
    
    methods (Static = true)
        function score = scoreMasks(masks)
            % cell array of masks
            mask = masks{1};
            for i = 2:length(masks)
                mask = mask & masks{i};
            end
            score = sum(mask(:));
        end
    end
    
end

