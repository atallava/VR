classdef parametricNoiseLaser < abstractLaserModule
	
	methods
		function obj = parametricNoiseLaser(laserClassInput)
			obj.laser = laserClass(laserClassInput);
		end
		
		function setMap(obj,map)
			compClock = tic();
			obj.map = map;
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function ranges = getReadings(obj,pose)
			compClock = tic();
			if isempty(obj.map)
				ranges = obj.getDefaultReadings();
				obj.tComp = obj.tComp+toc(compClock);
				return;
			end
			laserPose = obj.laser.refPoseToLaserPose(pose);
			ranges = obj.map.raycastNoisy(laserPose,obj.laser.maxRange,obj.laser.bearings);
			obj.tComp = obj.tComp+toc(compClock);
		end
	end
	
end