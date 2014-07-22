classdef errorOnKernelParams < handle
    %errorOnKernelParams Class to simplify optimization of kernel
    % parameters. 
    % Computes error of a regressor given some kernel parameters.

    properties (SetAccess = private)
        % regClass essentially needs to have a predict method. It can be a
        % regressor object or pixelRegressorBundle object.
        % regClassInput is a struct of inputs that only lacks the field
        % 'kernelParams'
        regClass
        regClassInput
    end
    
    properties
        XTest
        YTest
    end

    methods
        function obj = errorOnKernelParams(inputStruct)
            % inputStruct fields ('regClass','regClassInput','XTest','YTest')
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
            if isfield(inputStruct,'XTest')
                obj.XTest = inputStruct.XTest;
            else
            end
            if isfield(inputStruct,'YTest')
                obj.YTest = inputStruct.YTest;
            else
            end
        end
        
        function err = value(obj,kernelParams)
            % kernelParams is a struct, such as
            % struct('h',...,'lambda',...) 
            tempIn = obj.regClassInput;
            tempIn.kernelParams = kernelParams;
            tempReg = obj.regClass(tempIn);
            YPred = tempReg.predict(obj.XTest);
            errVec = abs(YPred-obj.YTest);
            errVec(isnan(errVec)) = [];
            outIds = errorStats.outlier1D(errVec(:));
            fprintf('nOuts: %d\n',sum(outIds));
            fprintf('outFrac: %d\n',sum(outIds)/numel(errVec));
            errVec(outIds) = [];
            err = mean(errVec);
        end
    end

    methods (Static = true)
    end

end
