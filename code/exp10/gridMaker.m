classdef gridMaker < handle
        
    properties
        scale = 0.03
        minPtsInElement = 5;
        pts
        nX; nY
        nElements
        xMin; xMax
        yMin; yMax
        xGrid; yGrid
        filledFlag
    end
    
    methods
        function obj = gridMaker(pts)
            obj.pts = pts;
            obj.gridUp();
            obj.findFilledElements();
        end
        
        function gridUp(obj)
            % pts is 2 x numPoints
            obj.xMin = min(obj.pts(1,:));
            obj.xMax = max(obj.pts(1,:));
            obj.yMin = min(obj.pts(2,:));
            obj.yMax = max(obj.pts(2,:));
            obj.xGrid = obj.xMin:obj.scale:obj.xMax;
            obj.nX = length(obj.xGrid);
            obj.yGrid = obj.yMin:obj.scale:obj.yMax;
            obj.nY = length(obj.yGrid);
            obj.nElements = obj.nX*obj.nY;
        end
        
        function hf = plotGrid(obj)
            hf = figure;
            plot(obj.pts(1,:),obj.pts(2,:),'r.')
            axis equal;
            hold on;
            for i = 1:length(obj.xGrid)
                plot([obj.xGrid(i) obj.xGrid(i)],[obj.yGrid(1) obj.yGrid(end)+obj.scale]);
            end
            plot([obj.xGrid(end)+obj.scale obj.xGrid(end)+obj.scale],[obj.yGrid(1) obj.yGrid(end)+obj.scale]);
            for i = 1:length(obj.yGrid)
                plot([obj.xGrid(1) obj.xGrid(end)+obj.scale],[obj.yGrid(i) obj.yGrid(i)]);
            end
                plot([obj.xGrid(1) obj.xGrid(end)+obj.scale],[obj.yGrid(end)+obj.scale obj.yGrid(end)+obj.scale]);
        end
        
        function [x,y] = id2xy(obj,id)
            assert(id <= obj.nElements,'ID > ELEMENTS.')
            ix = mod(id,obj.nX); 
            if ix == 0
                ix = obj.nX;
            end
            x = obj.xMin+(ix-1)*obj.scale;
            
            iy = floor(id/obj.nX);
            if ix == obj.nX
                iy = iy-1;
            end
            y = obj.yMin+iy*obj.scale;
        end
        
        function ptsElement = ptsInElement(obj,id)
            assert(id <= obj.nElements,'ID > ELEMENTS.')
            [x,y] = obj.id2xy(id);
            flag1 = x <= obj.pts(1,:) & obj.pts(1,:) < x+obj.scale;
            flag2 = y <= obj.pts(2,:) & obj.pts(2,:) < y+obj.scale;
            flag = flag1 & flag2;
            ptsElement = obj.pts(:,flag);
        end
        
        function findFilledElements(obj)
            obj.filledFlag = zeros(1,obj.nElements);
            for i = 1:obj.nElements
                ptsElement = obj.ptsInElement(i);
                if size(ptsElement,2) > obj.minPtsInElement
                    obj.filledFlag(i) = 1;
                end
            end
        end

    end
    
end

