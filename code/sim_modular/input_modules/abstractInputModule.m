classdef (Abstract) abstractInputModule < handle
	
	properties
		maxFifo = 1e2;                  % max length of command FIFOs
		vlHistory; vrHistory
		tHistory
		tComp = 0; % Time spent in computation.
	end
	
	methods (Abstract)
		fireUp(obj,time)
		[vl,vr] = getVelocitiesAtTime(obj,time)
		sendVelocity(obj,vl,vr,time)
	end
	
end