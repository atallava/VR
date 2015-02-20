classdef carvedObject < handle
	% associate elements with an object
		
	properties
		elements
		nElements
	end
	
	methods
		function obj = carvedObject(Tobj2world,elements)
			obj.elements = elements;
			obj.nElements = length(elements);
			for i = 1:obj.nElements
				pt = Tobj2world\[elements(i).mu; 1];
				obj.elements(i).mu = pt(1:2);
				R = Tobj2world(1:2,1:2);
				obj.elements(i).sigma = R\elements(i).sigma*R;
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
	end
	
end

