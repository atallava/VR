classdef localGeomRegressor < handle
    %localGeomRegressor Regressor based on neighbouring pixels.

    properties (SetAccess = private)
        % muArray - nPoses x nPixels
        muArray
        numNbrs = 2
        regClass
        regressorArray
        singleReg
        nPixels
    end

    methods
        function obj = localGeomRegressor(inputStruct)
            % inputStruct fields ('muArray','numNbrs','regClass', <regressor specific fields>)
            if isfield(inputStruct,'muArray')
                obj.muArray = inputStruct.muArray;
            else
                error('MUARRAY NOT INPUT.');
            end
            if isfield(inputStruct,'numNbrs')
                obj.numNbrs = inputStruct.numNbrs;
                if mod(obj.numNbrs,2) ~= 0
                    error('NUMNBRS MUST BE EVEN.');
                end
            else
            end
            if isfield(inputStruct,'regClass')
                obj.regClass = inputStruct.regClass;
            else
                error('REGCLASS NOT INPUT.');
            end
            obj.nPixels = size(obj.muArray,2);
            obj.fillPixelRegressorArray(inputStruct);        
        end
        
        function fillPixelRegressorArray(obj,inputStruct)
            obj.regressorArray = cell(1,obj.nPixels);
            bigX = []; bigY = [];
            
            for i = 1:obj.nPixels
                tempInput = inputStruct;
                [left,right] = obj.getNbrIds(i);
                tempInput.XTrain = [obj.muArray(:,left) obj.muArray(:,right)];
                tempInput.YTrain = obj.muArray(:,i);
                bigX = [bigX; obj.muArray(:,left) obj.muArray(:,right)];
                bigY = [bigY; obj.muArray(:,i)];
                obj.regressorArray{i} = obj.regClass(tempInput);
            end
            tempInput.XTrain = bigX; tempInput.YTrain = bigY;
            flag = isnan(bigX); flag = logical(sum(flag,2));
            tempInput.XTrain(flag,:) = []; tempInput.YTrain(flag) = [];
            
            obj.singleReg = obj.regClass(tempInput);
        end
        
        function res = predict(obj,ranges)
            % res - nPixels length array
            res = zeros(1,obj.nPixels);
            for i = 1:obj.nPixels
                [left,right] = obj.getNbrIds(i);
                if any(ranges([left i right]) == 0)
                    continue;
                else
                    %res(i) = obj.regressorArray{i}.predict([ranges(left) ranges(right)]);
                    res(i) = obj.singleReg.predict([ranges(left) ranges(right)]);
                end
            end
        end
        
        function [l,r] = getNbrIds(obj,i)
            l = i-obj.numNbrs/2:i-1;
            l(l<1) = l(l<1)+obj.nPixels;
            r = i+1:i+obj.numNbrs/2;
            r(r>obj.nPixels) = r(r>obj.nPixels)-obj.nPixels+1;
        end
    end
    

    methods (Static = true)
    end

end
