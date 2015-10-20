classdef (Abstract) abstractEncodersModule < handle
	
	properties (Access = protected)
		encoders = struct('data',struct('left',0,'right',0));
	end
	
	properties
		tComp = 0; % Time spent in computation.
	end
	
	methods (Abstract)
		updateEncoderValues(obj,vl,vr,dt,time)
		fireUp(obj,time)
		encoders = getEncoderValues(obj,time)
	end
end