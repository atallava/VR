classdef gridCarver < handle
        
    properties
        gridMade
        elements
        nElements
        perm % permeabilities
    end
    
    methods
        function obj = gridCarver(pts)
            obj.gridMade = gridMaker(pts);
            obj.fitElements();
        end
        
        function fitElements(obj)
            obj.elements = struct('mu',{},'sigma',{});
            obj.nElements = 0;
            for i = 1:obj.gridMade.nElements
                if obj.gridMade.filledFlag(i)
                    ptsElement = obj.gridMade.ptsInElement(i);
                    obj.nElements = obj.nElements+1;
                    obj.elements(obj.nElements).mu = mean(ptsElement,2);
                    obj.elements(obj.nElements).sigma = cov(ptsElement');
                end
            end
        end        
        
        function hf = plotElements(obj)
            hf = figure;
            plot(obj.gridMade.pts(1,:),obj.gridMade.pts(2,:),'r.')
            axis equal;
            hold on;
            for i = 1:obj.nElements
                [x,y] = getEllipsePoints(obj.elements(i).sigma);
                plot(x+obj.elements(i).mu(1),y+obj.elements(i).mu(2),'g','linewidth',2);
            end
        end
    end
    
end

