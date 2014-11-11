classdef optimizeParamsToIntegratedPose < handle
    %optimizeParamsToIntegratedPose

    properties (SetAccess = private)
        data
        wheelToBodyVel
        params0
        nParams
        delParams
        dParamsThresh = 1e-6;
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
            nData = length(obj.data);
            stackDelPose = zeros(3*nData,1);
            stackJ = zeros(3*nData,obj.nParams);
            params = obj.params0;
            dParams = Inf;
            while dParams > obj.dParamsThresh
                for i = 1:nData
                    [VArray,wArray] = obj.wheelToBodyVel(obj.data(i).vlArray,obj.data(i).vrArray,params);
                    predictedFinalPose = integrateVelocities(obj.data(i).startPose,VArray,wArray,obj.data(i).tArray);
                    delPose = pose2D.poseDiff(predictedFinalPose,obj.data(i).finalPose);
                    ids = 3*(i-1)+1:3*i;
                    stackDelPose(ids) = delPose;
                    J = getJacobianParamsToIntegratedPose(obj.data(i).startPose,obj.data(i).vlArray,obj.data(i).vrArray,obj.data(i).tArray,obj.wheelToBodyVel,params,obj.delParams);
                    stackJ(ids,:) = J;
                end
                dParams = (stackJ'*stackJ)\(stackJ'*stackDelPose);
                params = params+dParams;
            end
        end
    end

    methods (Static = true)
    end

end
