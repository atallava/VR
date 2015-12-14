classdef delayedNoisyInput < abstractInputModule
	
	properties
		tDelay
		delV
		delW
	end
	
	methods
		function obj = delayedNoisyInput(tDelay,delV,delW)
			obj.vlHistory = slidingFifoQueue(obj.maxFifo);
			obj.vrHistory = slidingFifoQueue(obj.maxFifo);
			obj.tHistory  = slidingFifoQueue(obj.maxFifo);
			obj.tDelay = tDelay;
			obj.delV = delV;
			obj.delW = delW;
		end
		
		function fireUp(obj,time)
			% Add zero velocities for specified time so interp1 works.
			obj.vlHistory.add(0.0);
			obj.vrHistory.add(0.0);
			% Extra microsecond for safety.
			obj.tHistory.add(time-obj.tDelay-1e-6); 
			obj.vlHistory.add(0.0);
			obj.vrHistory.add(0.0);
			obj.tHistory.add(time);
		end
		
		function [vl,vr] = getVelocitiesAtTime(obj,time)
			compClock = tic();
			% Hack to avoid nonunique timestamps
			if obj.tHistory.que(end) == obj.tHistory.que(end-1)
				obj.tHistory.que(end) = [];
				obj.vlHistory.que(end) = [];
				obj.vrHistory.que(end) = [];
			end
			% Hack to avoid que length mismatch;
			obj.cropQues();
			try
				vl = interp1(obj.tHistory.que,obj.vlHistory.que,time-obj.tDelay);
				vr = interp1(obj.tHistory.que,obj.vrHistory.que,time-obj.tDelay);
			catch
				length(obj.tHistory.que)
				length(obj.vlHistory.que)
				length(obj.vrHistory.que)
				
				if length(unique(obj.tHistory.que)) < length(obj.tHistory.que)
					obj.tHistory.que
					me = MException('delayedInput:nonUniqueTimestamps', ...
						'Non unique timestamps.');
					throw(me);
				end
				l1 = length(obj.tHistory.que);
				l2 = length(obj.vlHistory.que);
				l3 = length(obj.vrHistory.que);
				if ~all([l1 l2 l3] == l1)
					me = MException('delayedInput:queLengthMismatch', ...
						'Que length mismatch');
					throw(me);
				end
				
				error('Unknown error');
			end
			
			if isnan(vl) || isnan(vr)
				if time-obj.tDelay < obj.tHistory.que(1)
					% Perhaps sending velocities much faster than state update.
					me = MException('delayedInput:nanInterpolation', ...
						'Velocities requested at time less than time available in que.');
					throw(me);
				end
				obj.tHistory.que(end)
				obj.vlHistory.que(end)
				obj.vrHistory.que(end)
				me = MException('delayedInput:nanInterpolation','vl or vr is nan.');
				throw(me);
			end
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function sendVelocity(obj,vl,vr,time)
			compClock = tic();
			% Add errors!
			[V,w] = robotModel.vlvr2Vw(vl,vr);
			V = V+obj.delV*V;
			if (w > 0); w = w+obj.delW; end
			[vl,vr] = robotModel.Vw2vlvr(V,w);
			obj.tHistory.add(time);
			obj.vlHistory.add(vl);
			obj.vrHistory.add(vr);
			obj.tComp = obj.tComp+toc(compClock);
		end
		
		function cropQues(obj)
			l1 = length(obj.tHistory.que);
			l2 = length(obj.vlHistory.que);
			l3 = length(obj.vrHistory.que);
			if all([l1 l2 l3] == l1)
				return;
			else
				l = min([l1 l2 l3]);
				obj.tHistory.que = obj.tHistory.que(1:l);
				obj.vlHistory.que = obj.vlHistory.que(1:l);
				obj.vrHistory.que = obj.vrHistory.que(1:l);
			end
		end

	end
	
end