
classdef noisyInput < abstractInputModule
	% noisyInput adds error to input velocities
	
	properties
		delV
		delW
	end
	
	methods
		function obj = noisyInput(delV,delW)
			obj.vlHistory = slidingFifoQueue(obj.maxFifo);
			obj.vrHistory = slidingFifoQueue(obj.maxFifo);
			obj.tHistory  = slidingFifoQueue(obj.maxFifo);
			obj.delV = delV;
			obj.delW = delW;
		end
		
		function fireUp(obj,time)
			obj.vlHistory.add(0.0);
			obj.vrHistory.add(0.0);
			obj.tHistory.add(time);
		end
		
		function [vl,vr] = getVelocitiesAtTime(obj,time)
			compClock = tic();
			% Most recent input.
			vl = obj.vlHistory.que(end);
			vr = obj.vrHistory.que(end);
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function sendVelocity(obj,vl,vr,time)
			compClock = tic();
			% Add errors!
			[V,w] = robotModel.vlvrToVw(vl,vr);
			V = V+obj.delV*V;
			if (w > 0); w = w+obj.delW; end
			[vl,vr] = robotModel.VwTovlvr(V,w);
			obj.vlHistory.add(vl);
			obj.vrHistory.add(vr);
			obj.tHistory.add(time);
			obj.tComp = obj.tComp+toc(compClock);
		end
	end
end