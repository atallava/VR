classdef occupancyMap < handle
		
	properties
		scale % in m
		nX; nY
		nElements
		xMin; xMax
		yMin; yMax
		xGrid; yGrid
		logOddsGrid
		lInit; lOcc; lFree
		lzr
	end
	
	methods
		function obj = occupancyMap()
			obj.scale = 0.001;
			obj.lInit = obj.prob2LogOdds(0.5);
			obj.lOcc = obj.prob2LogOdds(0.8);
			obj.lFree = obj.prob2LogOdds(0.1);
		end
		
		function obj = gridUp(obj,mapSize)
			obj.xMin = mapSize(1,1); obj.xMax = mapSize(1,2);
			obj.yMin = mapSize(2,1); obj.yMax = mapSize(2,2);
			obj.xGrid = obj.xMin:obj.scale:obj.xMax;
            obj.nX = length(obj.xGrid);
            obj.yGrid = obj.yMin:obj.scale:obj.yMax;
            obj.nY = length(obj.yGrid);
            obj.nElements = obj.nX*obj.nY;
			obj.logOddsGrid = zeros(obj.nY,obj.nX);
		end
		
		function initLogOddsGrid(obj)
			obj.logOddsGrid(:) = obj.lInit;
		end
		
		function updateLogOdds(obj,pose,ranges)
			pts = zeros(2,obj.lzr.nPixels);
			pts(1,:) = pose(1)+ranges.*cos(obj.lzr.bearings+pose(3));
			pts(2,:) = pose(2)+ranges.*sin(obj.lzr.bearings+pose(3));
			
			[rStart,cStart] = obj.xy2rc(pose(1),pose(2));
			for i = 1:size(pts,2)
				[rEnd,cEnd] = obj.xy2rc(pts(1,i),pts(2,i));
				% bresenham needs flipped rows
				[~,~,~,r,c] = bresenham(zeros(size(obj.logOddsGrid)),[obj.nY-rStart+1 cStart; ...
					obj.nY-rEnd+1 cEnd],0);
				ids = obj.rc2id(r,c);
				% free space
				obj.logOddsGrid(ids(1:end-1)) = obj.logOddsGrid(ids(1:end-1))+obj.lFree-obj.lInit;
				% occupied space
				obj.logOddsGrid(ids(end)) = obj.logOddsGrid(ids(end))+obj.lOcc-obj.lInit;
			end
			
		end
		
		function [r,c] = xy2rc(obj,x,y)
			assert(x >= obj.xMin && x <= obj.xMax,'X NOT IN MAP RANGE');
			assert(y >= obj.yMin && y <= obj.yMax,'Y NOT IN MAP RANGE');
			c = ceil((x-obj.xMin)/obj.scale);
			r = ceil((y-obj.yMin)/obj.scale);
		end
		
		function [x,y] = rc2xy(obj,r,c)
			x = obj.xMin+(c-1)*obj.scale+obj.scale*0.5;
			y = obj.yMin+(r-1)*obj.scale+obj.scale*0.5;
		end
		
		function id = rc2id(obj,r,c)
			id = sub2ind([obj.nY obj.nX],r,c);
		end
		
		function [r,c] = id2rc(obj,id)
			[r,c] = sub2ind([obj.nY obj.nX],id);
		end
		
		function p = logOdds2Prob(obj,l)
			p = 1./(1+exp(-l));
		end
		
		function l = prob2LogOdds(obj,p)
			l = log(p/(1-p));
		end
		
		function hf = plotMap(obj)
			hf = figure;
			p = obj.logOdds2Prob(obj.logOddsGrid);
			imagesc(flipud(1-p));
			colormap(gray);
			xlabel('x');
			ylabel('y');
		end
	end
	
end

