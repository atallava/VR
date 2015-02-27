classdef carvedObject < handle
	%carvedObject Associate elements with an object.
		
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
			% simple interpolation: copy elements on sides
			assert(~isempty(obj.bBox),'BBOX CANNOT NOT BE EMPTY.')
			mus = [obj.elements(:).mu];
			flag = mus(1,:) <= 0;
			countX = max(sum(flag),length(flag)-sum(flag));
			flag = mus(2,:) <= 0;
			countY = max(sum(flag),length(flag)-sum(flag));
			if countX > countY
				obj.flipElements(1);
			else
				obj.flipElements(2);
			end
		end
		
		function flipElements(obj,d)
			% d = 1 for x-flip, 2 for y-flip
			mus = [obj.elements(:).mu];
			coords = mus(d,:);
			flag = coords <= 0;
			if sum(flag) > length(flag)-sum(flag)
				s = 1;
			else
				s = -1;
			end
			u = s*max(s*coords);
			ids = find(s*coords <= -s*u);
			R = eye(2);
			R(d,d) = -1;
			for i = ids
				elem = obj.elements(i);
				elem.mu = R*elem.mu;
				elem.sigma = R\elem.sigma*R;
				obj.elements(end+1) = elem;
				obj.nElements = obj.nElements+1;
			end
		end
		
		function hf = plot(obj,T)
			if nargin < 2
				T = eye(3);
			end
			els = obj.transformObject(T);
			hf = plotCarvedElements(els);
		end
	end
	
end

