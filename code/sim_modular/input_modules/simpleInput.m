classdef simpleInput < abstractInputModule
	
	properties
	end
	
	methods
		function obj = simpleInput()
			obj.vlHistory = slidingFifoQueue(obj.maxFifo);
			obj.vrHistory = slidingFifoQueue(obj.maxFifo);
			obj.tHistory  = slidingFifoQueue(obj.maxFifo);
		end
		
		function fireUp(obj,time)
			obj.vlHistory.add(0.0);
			obj.vrHistory.add(0.0);
			obj.tHistory.add(time);
		end
		
		function [vl,vr] = getVelocitiesAtTime(obj,time)
			compClock = tic();
			vl = obj.vlHistory.que(end);
			vr = obj.vrHistory.que(end);
			obj.tComp = obj.tComp+toc(compClock);
		end
				
		function sendVelocity(obj,vl,vr,time)
			compClock = tic();
			obj.vlHistory.add(vl);
			obj.vrHistory.add(vr);
			obj.tHistory.add(time);
			obj.tComp = obj.tComp+toc(compClock);
		end
	end
	
end

