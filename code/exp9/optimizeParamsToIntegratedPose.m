classdef optimizeParamsToIntegratedPose < handle
    %optimizeParamsToIntegratedPose class that does all the optimization

    properties (SetAccess = private)
        data
        wheelToBodyVel
        params0
        nParams
        delParams
        dParamsThresh = 1e-6;
		maxIter = 100;
	end

    methods
        function obj = optimizeParamsToIntegratedPose(inputStruct)
            % inputStruct fields ('data','wheelToBodyVel','params0','delParams')
			% data is a struct array with fields
			% ('startPose','finalPose','vlArray','vrArray','tArray')
			
			if isfield(inputStruct,'data')
                obj.data = inputStruct.data;
            else
                error('DATA NOT INPUT.');
            end
            if isfield(inputStruct,'wheelToBodyVel')
                obj.wheelToBodyVel = inputStruct.wheelToBodyVel;
            else
                error('WHEELTOBODYVEL NOT INPUT.');
            end
            if isfield(inputStruct,'params0')
                obj.params0 = inputStruct.params0;
            else
                error('PARAMS0 NOT INPUT.');
            end
            obj.nParams = length(obj.params0);
            if isfield(inputStruct,'delParams')
                obj.delParams = inputStruct.delParams;
			else
				error('DELPARAMS NOT INPUT.');
			end
		end
		
		function params = refineParams(obj)
% 			problem.objective = @(x) obj.calcObjective(x);
% 			problem.x0 = obj.params0;
% 			problem.lb = zeros(size(obj.params0));
% 			problem.solver = 'fmincon';
% 			problem.options = optimoptions('fmincon');
% 			params = fmincon(problem);
			
			params = obj.params0;
			nData = length(obj.data);
			stackDelPose = zeros(3*nData,1);
			stackJ = zeros(3*nData,obj.nParams);
			dParams = Inf;
			numIter = 0;
			while numIter < obj.maxIter
				numIter = numIter+1;
				for i = 1:nData
					[VArray,wArray] = obj.wheelToBodyVel(obj.data(i).vlArray,obj.data(i).vrArray,params);
					predictedFinalPose = integrateVelocities(obj.data(i).startPose,VArray,wArray,obj.data(i).tArray);
					delPose = pose2D.poseDiff(predictedFinalPose,obj.data(i).finalPose);
					ids = 3*(i-1)+1:3*i;
					stackDelPose(ids) = delPose;
					J = getJacobianParamsToIntegratedPose(obj.data(i).startPose, ...
						obj.data(i).vlArray,obj.data(i).vrArray,obj.data(i).tArray,obj.wheelToBodyVel,params,obj.delParams);
					stackJ(ids,:) = J;
				end
				dParams = (stackJ'*stackJ)\(stackJ'*stackDelPose);
				params = params+dParams;
			end
		end
		
		function poses = finalPosesWithParams(obj,params)
			poses = zeros(3,length(obj.data));
			for i = 1:length(obj.data)
				[VArray,wArray] = obj.wheelToBodyVel(obj.data(i).vlArray,obj.data(i).vrArray,params);
				poses(:,i) = integrateVelocities(obj.data(i).startPose,VArray,wArray,obj.data(i).tArray);		
			end
		end
		
		function res = calcObjective(obj,params)
			% sum of predicted pose diff squared
			res = 0;
			predictedFinalPoses = obj.finalPosesWithParams(params);
			for i = 1:length(obj.data);
				res = res+pose2D.poseNorm(predictedFinalPoses(:,i),obj.data(i).finalPose)^2;
			end
		end
	end

    methods (Static = true)
    end

end
