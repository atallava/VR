classdef calibratedLaser < abstractLaserModule
	
	properties
		lsim
	end
	
	methods
		function obj = calibratedLaser(laserClassInput)
			obj.laser = laserClass(laserClassInput);
			tmp = load('lsim_sep6_2');
			obj.lsim = tmp.lsim;
		end
		
		function setMap(obj,map)
			compClock = tic();
			obj.lsim.setMap(map);
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function ranges = getReadings(obj,pose)
			compClock = tic();
			ranges = obj.lsim.simulate(pose);
			obj.tComp = obj.tComp+toc(compClock);
		end
	end
	
end