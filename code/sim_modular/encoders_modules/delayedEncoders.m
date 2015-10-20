classdef delayedEncoders < abstractEncodersModule
		
	properties
		tDelay
		maxFifo = 100;                  % max length of command FIFOs
		leftHistory; rightHistory
		tHistory
	end
	
	methods
		function obj = delayedEncoders(tDelay)
			obj.tDelay = tDelay;
			obj.leftHistory = slidingFifoQueue(obj.maxFifo);
			obj.rightHistory = slidingFifoQueue(obj.maxFifo);
			obj.tHistory = slidingFifoQueue(obj.maxFifo);
		end
		
		function fireUp(obj,time)
			compClock = tic();
			% Add zero values for specified time so interp1 works.
			obj.leftHistory.add(0.0);
			obj.rightHistory.add(0.0);
			% Extra microsecond for safety.
			obj.tHistory.add(time-obj.tDelay-1e-6);
			obj.leftHistory.add(0.0);
			obj.rightHistory.add(0.0);
			obj.tHistory.add(time);
			
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
			
			obj.leftHistory.add(obj.encoders.data.left);
			obj.rightHistory.add(obj.encoders.data.right);
			obj.tHistory.add(time);
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function encoders = getEncoderValues(obj,time)
			compClock = tic();
			encoders.data.left = interp1(obj.tHistory.que,obj.leftHistory.que,time-obj.tDelay);
			encoders.data.right = interp1(obj.tHistory.que,obj.rightHistory.que,time-obj.tDelay);
			obj.tComp = obj.tComp+toc(compClock);
		end
	end
	
end