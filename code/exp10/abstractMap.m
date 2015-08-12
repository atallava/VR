classdef abstractMap < handle
		
	properties
	end
	
	methods (Abstract)
		hf = plot(obj)
		[ranges,incidence_angles] = raycast(obj,pose,maxRange,angRange)
	end
	
end

