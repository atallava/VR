classdef localGeomObjective < handle
    %localGeomObjective

    properties (SetAccess = private)
        % ranges is array of ranges
        % the alpha percentile from the likelihood of the training data
        % points is what we would like a patch to get to
        % tweakRadius - tweak cost is a high value outside the tweakRadius
        % outside the original point
        % tweakCostFlat is just a large number
        % lambda is weight to tweakCost
        ranges
        bearings
        x; y
        alpha = 0.1
        maxTweakFraction = 0.05;
        tweakRadius = 0.05; % in m
        tweakCostFlat = 100; 
        lambda
        localGeomExtent
        likelihoodScoreFlat
        pdf
    end

    methods
        function obj = localGeomObjective(inputStruct)
            % inputStruct fields ('ranges','bearings','alpha','lambda')
            % default (,,)
            if isfield(inputStruct,'ranges')
                obj.ranges = inputStruct.ranges;
            else
                error('RANGES NOT INPUT.');
            end
            if isfield(inputStruct,'ranges')
                obj.bearings = inputStruct.bearings;
            else
                error('BEARINGS NOT INPUT.');
            end
            obj.x = obj.ranges.*cos(obj.bearings);
            obj.y = obj.ranges.*sin(obj.bearings);
            if isfield(inputStruct,'alpha')
                obj.alpha = inputStruct.alpha;
            else
            end
            load density_data;
            obj.localGeomExtent = size(pdf.Mu,1);
            obj.likelihoodScoreFlat = quantile(sampleLogDensityValues,obj.alpha);
            obj.pdf = pdf;
            if isfield(inputStruct,'lambda')
                obj.lambda = inputStruct.lambda;
            else
                obj.lambda = obj.likelihoodScoreFlat/obj.normCost(obj.tweakRadius);
            end
        end
        
        function val = value(obj,dr)
            % dr is a set of tweaks
            score = obj.likelihoodScore(obj.ranges+dr);
            cost = obj.tweakCost(dr);
            val = -score+obj.lambda*cost;
        end
        
        function res = likelihoodScore(obj,r)
            res = 0;
            for i = 1:(length(r)-obj.localGeomExtent+1)
               section = r(i:i+obj.localGeomExtent-1);
               logDensity = getLogDensityAtLocation(obj.pdf,section);
               res = res+min(logDensity,obj.likelihoodScoreFlat);
            end
        end
        
        function res = tweakCost(obj,dr)
            dx = (obj.ranges+dr).*cos(obj.bearings)-obj.x;
            dy = (obj.ranges+dr).*sin(obj.bearings)-obj.y;
            tweakNorm = sqrt(dx.^2+dy.^2);
            res = sum(obj.normCost(tweakNorm));
        end
        
        function res = normCost(obj,tweakNorm)
            % tweakNorm is a vector of norm([dx dy]).
            res = tweakNorm;
            flag = tweakNorm > obj.tweakRadius;
            res(flag) = obj.tweakCostFlat;
        end
    end

    methods (Static = true)
    end

end
