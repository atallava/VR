classdef errorOnKernelParams < handle
    %errorOnKernelParams Class to simplify optimization of kernel
    % parameters.
    % Computes k-fold crossvalidation error of a regressor given some kernel parameters.

    properties (SetAccess = private)
        % regClass essentially needs to have a predict method. It can be a
        % regressor object or pixelRegressorBundle object.
        % regClassInput is a struct of inputs that only lacks the field
        % 'kernelParams'
        regClass
        regClassInput
    end
    
    properties
        k = 5;
        kIds
        XTrain
        YTrain
    end

    methods
        function obj = errorOnKernelParams(inputStruct)
            % inputStruct fields ('regClass','regClassInput')
            % default (,,,)
            if isfield(inputStruct,'regClass')
                obj.regClass = inputStruct.regClass;
            else
                error('REGCLASS NOT INPUT.');
            end
            if isfield(inputStruct,'regClassInput')
                obj.regClassInput = inputStruct.regClassInput;
            else
                error('REGCLASSINPUT NOT INPUT.');
            end
            obj.XTrain = obj.regClassInput.XTrain;
            obj.YTrain = obj.regClassInput.YTrain;
            obj.kIds = crossvalind('kfold',size(obj.XTrain,1),obj.k);
        end
        
        function err = value(obj,kernelParams)
            % kernelParams is a struct, such as
            % struct('h',...,'lambda',...) 
            tempIn = obj.regClassInput;
            tempIn.kernelParams = kernelParams;
            vec2 = [];
            for i = 1:obj.k
                testIds = obj.kIds == i;
                trainIds = ~testIds;
                tempIn.XTrain = obj.XTrain(trainIds,:);
                tempIn.YTrain = obj.YTrain(trainIds,:);
                tempReg = obj.regClass(tempIn);
                
                XTest = obj.XTrain(testIds,:);
                YTest = obj.YTrain(testIds,:); 
                YPred = tempReg.predict(XTest);
                YPred = squeeze(YPred);
                
                vec1 = abs(YPred-YTest);
                vec1(isnan(vec1)) = [];
                vec1 = vec1(:)';
                %outIds = errorStats.outlier1D(vec1(:));
                %vec1(outIds) = []
                vec2 = [vec2 vec1];
            end
            err = mean(vec2);
        end
    end

    methods (Static = true)
    end

end
