classdef carvedObject < handle
	% associate elements with an object
		
	properties
		bBox
		elements
		nElements
	end
	
	methods
		function obj = carvedObject(inputStruct)
			% inputStruct fields ('Tobj2world','elements','bBox')
			% default (,,)
			if ~isfield(inputStruct,'Tobj2world')
				inputStruct.Tobj2world = eye(3);
			end
			assert(isfield(inputStruct,'elements'),'INPUTSTRUCT MUST CONTAIN ELEMENTS');
			obj.elements = inputStruct.elements;
			obj.nElements = length(obj.elements);
			if isfield(inputStruct,'bBox')
				obj.bBox = inputStruct.bBox;
			end
			
			for i = 1:obj.nElements
				pt = inputStruct.Tobj2world\[obj.elements(i).mu; 1];
				obj.elements(i).mu = pt(1:2);
				R = inputStruct.Tobj2world(1:2,1:2);
				obj.elements(i).sigma = R\obj.elements(i).sigma*R;
			end
		end
		
		function elements = transformObject(obj,Tobj2world)
			elements = obj.elements;
			for i = 1:obj.nElements
				pt = Tobj2world*[obj.elements(i).mu; 1];
				elements(i).mu = pt(1:2);
				R = Tobj2world(1:2,1:2);
				elements(i).sigma = R*obj.elements(i).sigma/R;
			end
		end
		
		function interpolateElements(obj)
			assert(~isempty(obj.bBox),'BBOX CANNOT NOT BE EMPTY.')
			mus = [obj.elements(:).mu];
			flag = mus(1,:) <= 0;
			countX = max(sum(flag),length(flag)-sum(flag));
			flag = mus(2,:) <= 0;
			countY = max(sum(flag),length(flag)-sum(flag));
			if countX > countY
				obj.flipHorizontal();
			else
				obj.flipVertical();
			end
		end
		
		function flipHorizontal(obj)
			mus = [obj.elements(:).mu];
			x = mus(1,:);
			flag = x <= 0;
			if sum(flag) > length(flag)-sum(flag)
				s = 1;
			else
				s = -1;
			end
			u = s*max(s*x);
			ids = find(s*x <= -s*u);
			R = [-1 0; 0 1];
			for i = ids
				elem.mu = R*obj.elements(i).mu;
				elem.sigma = R\obj.elements(i).sigma*R;
				obj.elements(end+1) = elem;
				obj.nElements = obj.nElements+1;
			end
		end
		
		function flipVertical(obj)
			mus = [obj.elements(:).mu];
			y = mus(2,:);
			flag = y <= 0;
			if sum(flag) > length(flag)-sum(flag)
				s = 1;
			else
				s = -1;
			end
			u = s*max(s*y);
			ids = find(s*y <= -s*u);
			R = [1 0; 0 -1];
			for i = ids
				elem.mu = R*obj.elements(i).mu;
				elem.sigma = R\obj.elements(i).sigma*R;
				obj.elements(end+1) = elem;
				obj.nElements = obj.nElements+1;
			end
		end
		
		function hf = plot(obj,T)
			if nargin < 2
				T = eye(3);
			end
			hf = figure;
			axis equal;
			hold on;
			els = obj.transformObject(T);
			for i = 1:length(els)
				[x,y] = getEllipsePoints(els(i).sigma);
				plot(x+els(i).mu(1),y+els(i).mu(2),'g','linewidth',2);
				plot(els(i).mu(1),els(i).mu(2),'bo');
			end
		end
	end
	
end

