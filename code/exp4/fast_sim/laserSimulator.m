classdef laserSimulator < handle
	%laserSimulator 
	% Authors: Abhijeet Tallavajhula
	
	properties
		meanPredictors
		sigmaPredictors
		pNull
		bearings
		maxRange = 4.5; % in m.
		map
	end
	
	methods
		function obj = laserSimulator(meanPredictors,sigmaPredictors,pNull,bearings)
			%LASERSIMULATOR Constructor
			%
			% obj = LASERSIMULATOR(meanPredictors,sigmaPredictors,pNull,bearings)
			%
			% meanPredictors  - Cell array of mean predictor polynomials.
			% sigmaPredictors - Cell array of variance predictor polynomials.
			% pNull           - Array of null reading probabilities.
			% bearings        - Array of laser bearings in rad.
			
			obj.meanPredictors = meanPredictors;
			obj.sigmaPredictors = sigmaPredictors;
			obj.pNull = pNull;
			obj.bearings = bearings;
		end
		
		function setMap(obj,map)
			%SETMAP
			%
			% SETMAP(obj,map)
			%
			% map - lineMap instance.

			obj.map = map;
		end
		
		function ranges = simulate(obj,pose)
			%SIMULATE Predict ranges at pose.
			%
			% ranges = SIMULATE(obj,pose)
			%
			% pose   - Vector of [x,y,theta].
			%
			% ranges - Array of size(obj.bearings)
			
			if isempty(obj.map)
				error('MAP NEEDS TO BE SET.');
			end
			[r,~] = obj.map.getRAlpha(pose,obj.maxRange,obj.bearings);
			ranges = zeros(1,length(obj.bearings));
			for i = 1:length(obj.bearings)
				if isnan(r(i))
					% Out of range.
					ranges(i) = 0;
					continue;
				end
				mu = polyval(obj.meanPredictors{i},r(i));
				s = polyval(obj.sigmaPredictors{i},r(i));
				if isnan(s)
					error('a');
				end
				if (s < 0); s = 0; end
				val = normrnd(mu,s);
				if isnan(val)
					error('b');
				end
				toss = rand();
				if toss < obj.pNull(i)
					ranges(i) = 0;
				else
					ranges(i) = val;
				end
			end
		end
	end
	
end

