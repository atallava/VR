classdef localGeomObjective < handle
    %localGeomObjective

    properties (SetAccess = private)
        % ranges is array of ranges
        % alpha decides threshold for likelihood
        % lambda is weight to tweaking
        ranges
        alpha = 0.1
        maxTweakFraction = 0.1;
        lambda
        localGeomExtent
        likelihoodScoreFlat
        pdf
    end

    methods
        function obj = localGeomObjective(inputStruct)
            % inputStruct fields ('ranges','alpha','lambda')
            % default (,,)
            if isfield(inputStruct,'ranges')
                obj.ranges = inputStruct.ranges;
            else
                error('RANGES NOT INPUT.');
            end
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
                obj.lambda = obj.likelihoodScoreFlat/min(0.2*obj.alpha,obj.maxTweakFraction);
            end
        end
        
        function val = value(obj,dr)
            % dr is a set of tweaks
            score =obj.likelihoodScore(obj.ranges+dr);
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
            drRelative = dr./obj.ranges;
            res = sum(abs(drRelative));
        end
    end

    methods (Static = true)
    end

end
