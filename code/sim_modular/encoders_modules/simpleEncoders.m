classdef simpleEncoders < abstractEncodersModule
	
	methods
		function obj = simpleEncoders()
		end
		
		function fireUp(obj,time)
			compClock = tic();
			obj.encoders.data.left = 0;
			obj.encoders.data.right = 0;
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function updateEncoderValues(obj,vl,vr,dt,time)
			compClock = tic();
			dl = vl*dt*1000.0;
			dr = vr*dt*1000.0;
            obj.encoders.data.left = ...
                obj.encoders.data.left + dl;
			obj.encoders.data.right = ...
                obj.encoders.data.right + dr;
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function encoders = getEncoderValues(obj,time)
			compClock = tic();
			encoders = obj.encoders;
			obj.tComp = obj.tComp+toc(compClock);
		end
	end
	
end