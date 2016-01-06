classdef occupancyMap < abstractMap
		
	properties
		scale % in m
        xyLims % [xMin xMax; yMin yMax]
		nX; nY
		nElements
		xMin; xMax
		yMin; yMax
		xGrid; yGrid
		logOddsGrid
		binaryGrid
        pInit; pOcc; pFree
		lInit; lOcc; lFree
		laser
        distThreshForAlpha = 0.02; % in cm
	end
	
	methods
        function obj = occupancyMap(inputStruct)
            % inputStruct fields
            % ('laser','scale','xyLims','pInit','pOcc','pFree')
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
            if isfield(inputStruct,'xyLims')
                obj.xyLims = inputStruct.xyLims;
            else
                obj.xyLims = [-5 5; -5 5];
            end
            if isfield(inputStruct,'pInit')
                obj.pInit = inputStruct.pInit;
            else
                obj.pInit = 0.5;
            end
            if isfield(inputStruct,'pOcc')
                obj.pOcc = inputStruct.pOcc;
            else
                obj.pOcc = 0.8;
            end
            if isfield(inputStruct,'pFree')
                obj.pFree = inputStruct.pFree;
            else
                obj.pFree = 0.1;
            end
                        
			obj.lInit = obj.prob2LogOdds(obj.pInit);
			obj.lOcc = obj.prob2LogOdds(obj.pOcc);
			obj.lFree = obj.prob2LogOdds(obj.pFree);
            obj.gridUp(obj.xyLims);
			obj.initLogOddsGrid();
		end
		
		function obj = gridUp(obj,xyLims)
			obj.xMin = xyLims(1,1); obj.xMax = xyLims(1,2);
			obj.yMin = xyLims(2,1); obj.yMax = xyLims(2,2);
			obj.xGrid = obj.xMin:obj.scale:obj.xMax;
            obj.nX = length(obj.xGrid)-1;
            obj.yGrid = obj.yMin:obj.scale:obj.yMax;
            obj.nY = length(obj.yGrid)-1;
            obj.nElements = obj.nX*obj.nY;
			obj.logOddsGrid = zeros(obj.nY,obj.nX);
		end
		
		function initLogOddsGrid(obj)
			obj.logOddsGrid(:) = obj.lInit;
        end
		
        function [r,c] = xy2rc(obj,x,y)
            condn = all(x >= obj.xMin) && all(x <= obj.xMax);
			assert(condn,'occupancyMap:outOfMap','Query x out of map range.');
            condn = all(y >= obj.yMin) && all(y <= obj.yMax);
			assert(condn,'occupancyMap:outOfMap','Query y out of map range.');
			c = ceil((x-obj.xMin)./obj.scale); 
            % a tiny fraction of the map can spill over
            c(c > obj.nX) = obj.nX;
			r = ceil((y-obj.yMin)./obj.scale); 
            r(r > obj.nY) = obj.nY;
		end
		
		function [x,y] = rc2xy(obj,r,c)
			x = obj.xMin+(c-1)*obj.scale+obj.scale*0.5;
			y = obj.yMin+(r-1)*obj.scale+obj.scale*0.5;
		end
		
		function id = rc2id(obj,r,c)
			id = sub2ind([obj.nY obj.nX],r,c);
		end
		
		function [r,c] = id2rc(obj,id)
			[r,c] = ind2sub([obj.nY obj.nX],id);
		end
		
		function updateLogOdds(obj,pose,ranges,bearings)
            %UPDATELOGODDS Update odds corresponding to single pose.
            %
            % UPDATELOGODDS(obj,pose,ranges,bearings)
            %
            % pose     - 
            % ranges   - 
            % bearings - 
            
			if nargin < 4
				bearings = obj.laser.bearings;
			end
			pts = zeros(2,length(bearings));
			pts(1,:) = pose(1)+ranges.*cos(bearings+pose(3));
            pts(2,:) = pose(2)+ranges.*sin(bearings+pose(3));
            
            rcStart = zeros(1,2);
            [rcStart(1),rcStart(2)] = obj.xy2rc(pose(1),pose(2));
            for i = 1:size(pts,2)
                rcEnd = zeros(1,2);
                if ranges(i) == obj.laser.nullReading
                    continue;
                end
                try
                    [rcEnd(1),rcEnd(2)] = obj.xy2rc(pts(1,i),pts(2,i));
                catch
                    % ignore point if it happens to lie outside limits
                    % TODO: fix this so it snaps to boundary of map
                    continue;
                end
                ids = obj.bresenhamWrapper(rcStart,rcEnd);
                if isempty(ids)
                    disp('x');
                    continue;
                end
                % free space
                obj.logOddsGrid(ids(1:end-1)) = obj.logOddsGrid(ids(1:end-1))+obj.lFree-obj.lInit;
                % occupied space
                obj.logOddsGrid(ids(end)) = obj.logOddsGrid(ids(end))+obj.lOcc-obj.lInit;
            end
        end
        
        function processRanges(obj,poses,ranges,bearings)
            %PROCESSRANGES Update log odds for many poses.
            %
            % PROCESSRANGES(obj,poses,ranges)
            %
            % poses  -
            % ranges -
            % bearings -
            
            nPoses = size(poses,1);
            for i = 1:nPoses
                obj.updateLogOdds(poses(i,:),ranges(i,:),bearings);
            end
        end
        
        function ids = bresenhamWrapper(obj,rcStart,rcEnd)
            %BRESENHAMWRAPPER Simple wrapper over file exchange bresenham.
            %
            % ids = BRESENHAMWRAPPER(obj,rcStart,rcEnd)
            %
            % rcStart - Length 2 array.Row and column of ray start.
            % rcEnd   - Length 2 array.Row and column of ray end.
            %
            % ids     - Array of ids the ray passes through.
            
            rStart = rcStart(1); cStart = rcStart(2);
            rEnd = rcEnd(1); cEnd = rcEnd(2);
            % bresenham needs flipped rows
            % also returns c,r in reverse order of array indexing
            bresenhamPts = [obj.nY-rStart+1 cStart; ...
                obj.nY-rEnd+1 cEnd];
            bresenhamPts = fliplr(bresenhamPts);
            [~,~,~,r,c] = bresenham(zeros(obj.nY,obj.nX),bresenhamPts,0);
%             try
%                 [~,~,~,r,c] = bresenham(zeros(obj.nY,obj.nX),bresenhamPts,0);
%             catch
%                 error;
%                 % unknown failure
%                 ids = [];
%                 return;
%             end
            r = obj.nY-r+1;
            if r(1) ~= rStart; r = fliplr(r); end
            if c(1) ~= cStart; c = fliplr(c); end
            ids = obj.rc2id(r,c);
        end
        
		function p = logOdds2Prob(obj,l)
            p = 1./(1+exp(-l));
            flag1 = isinf(l) & l > 0;
            flag2 = isinf(l) & l < 0;
            p(flag1) = 1;
            p(flag2) = 0;
		end
		
		function l = prob2LogOdds(obj,p)
			l = log(p./(1-p));
            flag1 = (p == 1);
            flag2 = (p == 0);
            l(flag1) = Inf;
            l(flag2) = -Inf;
		end
		
		function hf = plotGrid(obj)
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
            
            % data cursor display
            dcmObj = datacursormode(hf);
            set(dcmObj,'UpdateFcn',@(src,evt) occupancyMap.tagPlotPointWithXY(src,evt,obj));
		end
		
		function hf = plotBinaryGrid(obj)
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
            
            % data cursor display
            dcmObj = datacursormode(hf);
            set(dcmObj,'UpdateFcn',@(src,evt) occupancyMap.tagPlotPointWithXY(src,evt,obj));
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
        
        function probGrid = getProbGrid(obj)
           probGrid = obj.logOdds2Prob(obj.logOddsGrid);
        end
        
        function nll = calcNegLogLike(obj,binaryGrid)
            %CALCNEGLOGLIKE
            %
            % nll = CALCNEGLOGLIKE(obj,binaryGrid)
            %
            % binaryGrid -
            %
            % nll       -
            
            condn = isequal(size(binaryGrid),size(obj.logOddsGrid));
            assert(condn,'occupancyMap:sizeMismatch','binaryMap must be same size as occupancy map.');
            occFlag = logical(binaryGrid);
            probGrid = obj.getProbGrid();
            v1 = log(probGrid(occFlag));
            v2 = log(1-probGrid(~occFlag));
            % TODO: only considering positive obstacles
            %nll = -(sum(v1)+sum(v2));
            nll = -sum(v1);
        end
        
        function [ranges,incidenceAngles] = raycast(obj,pose,maxRange,thRange)
            [ranges,incidenceAngles] = obj.getRAlpha(pose,maxRange,thRange);
            ranges(isnan(ranges)) = 0;
        end
		
		function [ranges,incidenceAngles] = getRAlpha(obj,pose,maxRange,thRange)
            condn = pose(1) >= obj.xMin && pose(1) <= obj.xMax;
            assert(condn,'occupancyMap:outOfMap','Pose x out of map range.');
            condn = pose(2) >= obj.yMin && pose(2) <= obj.yMax;
            assert(condn,'occupancyMap:outOfMap','Pose y out of map range.');
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
            %FARTHESTPOINTONRAY
            % shoot a ray from x1,y1 in the direction th. which is the
			% farthest point on the map it reaches?
            %
            % [x2,y2] = FARTHESTPOINTONRAY(obj,x1,y1,th)
            %
            % x1  -
            % y1  -
            % th  -
            %
            % x2  -
            % y2  -

			% this can be made faster using lineMap. but currently not
			% needed since this isn't bottleneck.
			
            condn = all(x1 >= obj.xMin) && all(x1 <= obj.xMax);
            assert(condn,'occupancyMap:outOfMap','x1 out of map range.');
			condn = all(y1 >= obj.yMin) && all(y1 <= obj.yMax);
			assert(condn,'occupancyMap:outOfMap','y1 out of map range.');
						
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
        
        function mapScaled = subscaleMap(obj,scaleQuery)
            %SUBSCALEMAP
            %
            % mapScaled = SUBSCALEMAP(obj,scaleQuery)
            %
            % scaleQuery -
            %
            % mapScaled  -
            
            condn = scaleQuery <= obj.scale;
            assert(condn,'occupancyMap:subscaleError','Query scale must be less than map scale: %.2f.\n',obj.scale);
            inputStruct = struct('laser',obj.laser,'xyLims',obj.xyLims,...
                'scale',scaleQuery);
            mapScaled = occupancyMap(inputStruct);
            
            [cSmall,rSmall] = meshgrid(1:mapScaled.nX,1:mapScaled.nY);
            rSmall = flipud(rSmall);
            cSmall = cSmall(:); rSmall = rSmall(:);
            [xSmall,ySmall] = mapScaled.rc2xy(rSmall,cSmall);
            [rSmall2Big,cSmall2Big] = obj.xy2rc(xSmall,ySmall);
            % takes a cell in scaledMap to a cell in obj
            % TODO: get rid of all this jugglery by being consistent with
            % M's treatment of matrices.
            rSmall2Big = obj.nY-rSmall2Big+1; 
            idSmall2Big = sub2ind(size(obj.logOddsGrid),rSmall2Big,cSmall2Big);
            
            vec = obj.logOddsGrid(idSmall2Big);
            mapScaled.logOddsGrid = reshape(vec,size(mapScaled.logOddsGrid));
        end
    end
    
    methods (Static)
        function txt = tagPlotPointWithXY(src,evt,obj)
            pos = get(evt,'Position');
            c = pos(1); r = obj.nY-pos(2)+1;
            [x,y] = obj.rc2xy(r,c);
            txt = {['x: ',num2str(x)],...
                ['y: ',num2str(y)]};
        end
    end
end

