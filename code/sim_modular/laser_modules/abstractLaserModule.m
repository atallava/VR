classdef (Abstract) abstractLaserModule < handle
	
	properties (Access = protected)
		map
		laser
	end
	
	properties
		tComp = 0; % Time spent in computation.
	end
	
	methods (Abstract)
		ranges = getReadings(obj,pose);
		setMap(obj,map);
	end
	
	methods
		function ranges = defaultReadings(obj)
			ranges = obj.laser.nullReading*ones(1,obj.laser.nBearings);
		end
	end
end