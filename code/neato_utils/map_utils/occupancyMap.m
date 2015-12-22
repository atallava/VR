classdef occupancyMap < abstractMap
		
	properties
		scale % in m
        mapSize
		nX; nY
		nElements
		xMin; xMax
		yMin; yMax
		xGrid; yGrid
		logOddsGrid
		binaryGrid
		lInit; lOcc; lFree
		laser
        distThreshForAlpha = 0.02; % in cm
	end
	
	methods
        function obj = occupancyMap(inputStruct)
            % mapSize = [xMin xMax; yMin yMax]
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
                obj.laser = laserClass(struct());
            end
            if isfield(inputStruct,'scale')
                obj.scale = inputStruct.scale;
            else
                obj.scale = 0.01;
            end
            if isfield(inputStruct,'mapSize')
                obj.mapSize = inputStruct.mapSize;
            else
                obj.mapSize = [-5 5; -5 5];
            end
			obj.lInit = obj.prob2LogOdds(0.5);
			obj.lOcc = obj.prob2LogOdds(0.8);
			obj.lFree = obj.prob2LogOdds(0.1);
            obj.gridUp(obj.mapSize);
			obj.initLogOddsGrid();
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
		
		function updateLogOdds(obj,pose,ranges,bearings)
			if nargin < 4
				bearings = obj.laser.bearings;
			end
			pts = zeros(2,length(bearings));
			pts(1,:) = pose(1)+ranges.*cos(bearings+pose(3));
			pts(2,:) = pose(2)+ranges.*sin(bearings+pose(3));
			
			[rStart,cStart] = obj.xy2rc(pose(1),pose(2));
			for i = 1:size(pts,2)
				if ranges(i) == obj.laser.nullReading
					continue;
                end
                try
                    [rEnd,cEnd] = obj.xy2rc(pts(1,i),pts(2,i));
                catch
                    % ignore point if it happens to lie outside limits
                    % fix this so it snaps to boundary of map
                    continue;
                end
				% bresenham needs flipped rows
				% also returns x,y in reverse order of array indexing
				[~,~,~,c,r] = bresenham(zeros(size(obj.logOddsGrid)),[obj.nY-rStart+1 cStart; ...
					obj.nY-rEnd+1 cEnd],0);
				r = obj.nY-r+1;
				if r(1) ~= rStart; r = fliplr(r); end
				if c(1) ~= cStart; c = fliplr(c); end
				ids = obj.rc2id(r,c);
				% free space
				obj.logOddsGrid(ids(1:end-1)) = obj.logOddsGrid(ids(1:end-1))+obj.lFree-obj.lInit;
				% occupied space
				obj.logOddsGrid(ids(end)) = obj.logOddsGrid(ids(end))+obj.lOcc-obj.lInit;
			end
		end
		
		function [r,c] = xy2rc(obj,x,y)
			assert(all(x >= obj.xMin) && all(x <= obj.xMax),'X NOT IN MAP RANGE');
			assert(all(y >= obj.yMin) && all(y <= obj.yMax),'Y NOT IN MAP RANGE');
			c = ceil((x-obj.xMin)./obj.scale);
			r = ceil((y-obj.yMin)./obj.scale);
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
			xlabel('x (m)');
			ylabel('y (m)');
			axis equal;
            
            % euclidean ticks
            ax = gca;
            c = ax.XTick;
            [x,~] = obj.rc2xy([],c);
            ax.XTickLabel = x;
            r = ax.YTick;
            [~,y] = obj.rc2xy(r,[]);
            ax.YTickLabel = flip(y);            
		end
		
		function hf = plotBinaryMap(obj)
			hf = figure;
			p = obj.logOdds2Prob(obj.logOddsGrid);
			p = p > 0.5;
			imagesc(flipud(1-p));
			colormap(gray);
			xlabel('x (m)');
			ylabel('y (m)');
			axis equal;

            % euclidean ticks
            ax = gca;
            c = ax.XTick;
            [x,~] = obj.rc2xy([],c);
            ax.XTickLabel = x;
            r = ax.YTick;
            [~,y] = obj.rc2xy(r,[]);
            ax.YTickLabel = flip(y);            
		end
		
		function hf = plot(obj)
			hf = obj.plotBinaryMap();
		end
		
		function calcBinaryGrid(obj)
			obj.binaryGrid = obj.logOdds2Prob(obj.logOddsGrid);
			obj.binaryGrid = obj.binaryGrid > 0.5;
		end
		
		function p = getBinaryGrid(obj)
			if isempty(obj.binaryGrid)
				obj.calcBinaryGrid();
			end
			p = obj.binaryGrid;
        end
        
        function [ranges,incidenceAngles] = raycast(obj,pose,maxRange,thRange)
            [ranges,incidenceAngles] = obj.getRAlpha(pose,maxRange,thRange);
            ranges(isnan(ranges)) = 0;
        end
		
		function [ranges,incidenceAngles] = getRAlpha(obj,pose,maxRange,thRange)
            assert(pose(1) >= obj.xMin && pose(1) <= obj.xMax,'X NOT IN MAP RANGE');
			assert(pose(2) >= obj.yMin && pose(2) <= obj.yMax,'Y NOT IN MAP RANGE');
			numPts = length(thRange);

			sweep = pose(3)+thRange;
			x1 = pose(1)*ones(1,numPts);
			y1 = pose(2)*ones(1,numPts);
			[x2,y2] = deal(zeros(size(x1)));
			for i = 1:numPts
				[x2(i),y2(i)] = obj.farthestPointOnRay(x1(i),y1(i),sweep(i));
			end
			[r1,c1] = obj.xy2rc(x1,y1);
			[r2,c2] = obj.xy2rc(x2,y2);
			[xHit,yHit] = deal(zeros(1,numPts));
			ranges = zeros(1,numPts);
			for i = 1:numPts
				[~,~,~,c,r] = bresenham(zeros(size(obj.binaryGrid)),[obj.nY-r1(i)+1 c1(i); ...
					obj.nY-r2(i)+1 c2(i)],0);
				r = obj.nY-r+1;
				if r(1) ~= r1(i); r = fliplr(r); end
				if c(1) ~= c1(i); c = fliplr(c); end
				ids = obj.rc2id(r,c);
								
				hits = find(obj.binaryGrid(ids));
				if isempty(hits)
					xHit(i) = nan; yHit(i) = nan;
					ranges(i) = nan;
				else
					hit = hits(1); % closest hit
					[xHit(i),yHit(i)] = obj.rc2xy(r(hit),c(hit));
					range = norm([xHit(i)-x1(i),yHit(i)-y1(i)]);
					if range <= maxRange
						ranges(i) = range;
					else
						ranges(i) = nan;
					end
				end
            end
            
            % incidence angles by fitting lines to nearby points
            incidenceAngles = zeros(size(ranges));
            pts = zeros(2,length(thRange));
            pts(1,:) = pose(1)+ranges.*cos(pose(3)+thRange);
            pts(2,:) = pose(2)+ranges.*sin(pose(3)+thRange);
            for i = 1:numPts
                if ranges(i) == obj.laser.nullReading
                    continue;
                end
                
                [l,r] = circArray.circNbrs(i,length(thRange),2);
                if norm(pts(:,i)-pts(:,l)) < obj.distThreshForAlpha
                    lineParams = parametrizePts2ABC(pts(:,i),pts(:,l));
                elseif norm(pts(:,i)-pts(:,l)) < obj.distThreshForAlpha
                    lineParams = parametrizePts2ABC(pts(:,i),pts(:,r));
                else
                    continue;
                end

                % use more than one neighbour
%                 k = 2;
%                 [l,r] = circArray.circNbrs(i,length(thRange),2);
%                 linePts = pts(:,i);
%                 for j = [l r]
%                     if norm(pts(:,j)-pts(:,i)) < obj.distThreshForAlpha
%                         linePts = [linePts pts(:,j)];
%                     end
%                 end
%                 if size(linePts,2) == 1
%                     continue;
%                 end
%                 linefit = polyfit(linePts(1,:),linePts(2,:),1);
%                 lineParams(1) = 1; lineParams(2) = -linefit(1);
                
                % messy bit of code lifted from lineMap.raycast
                alpha = atanLine2D(lineParams(1),lineParams(2));
                beta = alpha-mod(pose(3)+thRange(i),pi);
                if beta == 0; beta = pi; end
                beta = beta-pi/2*sign(beta);
                incidenceAngles(i) = beta;
            end
            
        end
		
		function [x2,y2] = farthestPointOnRay(obj,x1,y1,th)
			% shoot a ray from x1,y1 in the direction th. which is the
			% farthest point on the map it reaches.
			% this can be made faster using lineMap. but currently not
			% needed since this isn't bottleneck.
			
			assert(all(x1 >= obj.xMin) && all(x1 <= obj.xMax),'X NOT IN MAP RANGE');
			assert(all(y1 >= obj.yMin) && all(y1 <= obj.yMax),'Y NOT IN MAP RANGE');
			
			th = mod(th,2*pi);
			% angles with vertices
			thVertices = zeros(1,4);
			vec = [obj.xMax;obj.yMax]-[x1;y1];
			thVertices(1) = atan2(vec(2),vec(1));
			vec = [obj.xMin;obj.yMax]-[x1;y1];
			thVertices(2) = atan2(vec(2),vec(1));
			vec = [obj.xMin;obj.yMin]-[x1;y1];
			thVertices(3) = atan2(vec(2),vec(1));
			vec = [obj.xMax;obj.yMin]-[x1;y1];
			thVertices(4) = atan2(vec(2),vec(1));
			thVertices = mod(thVertices,2*pi);
			
			del = 1e-3;
			if thVertices(1) <= th && th < thVertices(2)
				y2 = obj.yMax-del;
				x2 = (y2-y1)/tan(th)+x1;
			elseif thVertices(2) <= th && th < thVertices(3)
				x2 = obj.xMin+del;
				y2 = (x2-x1)*tan(th)+y1;
			elseif thVertices(3) <= th && th < thVertices(4)
				y2 = obj.yMin+del;
				x2 = (y2-y1)/tan(th)+x1;
			else
				x2 = obj.xMax-del;
				y2 = (x2-x1)*tan(th)+y1;
			end
		end
	end
	
end

