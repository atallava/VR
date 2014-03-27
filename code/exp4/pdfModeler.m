classdef pdfModeler < handle
    %pdfModeler fit parametric distribution to range data
        
    properties
        % fitClass is a handle to the fitting class
        % fitArray is a num pixels length array of fitClass instances
        % data is num poses x num observations x num pixels
        % nParams is number of params used by fitName
        % paramArray is num poses x num parameters x num pixels
        % nLLArray is num poses x num pixels, array of negative log
        % likelihoods
        fitClass
        fitArray
        data
        nPixels
        nParams
        paramArray
        nllArray
    end
    
    methods
        function obj = pdfModeler(inputData)
            % inputData fields ('fitClass','data')
            obj.fitClass = inputData.fitClass;
            obj.data = inputData.data;
            obj.nPixels = size(obj.data,3);
            tempObj = obj.fitClass(0,0);
            obj.nParams = tempObj.nParams;
            obj.fillParamArray();
        end
        
        function fillParamArray(obj)
            nPoses = size(obj.data,1);
            obj.paramArray = zeros(nPoses,obj.nParams,obj.nPixels);
            obj.fitArray = cell(1,obj.nPixels);
            obj.nllArray = zeros(nPoses,obj.nPixels);
            for i = 1:nPoses
                for j = 1:obj.nPixels
                    tempData = squeeze(obj.data(i,:,j));
                    obj.fitArray{i} = obj.fitClass(tempData,0);
                    obj.paramArray(i,:,j) = obj.fitArray{i}.getParams();
                    obj.nllArray(i,j) = obj.fitArray{i}.nll;
                end
            end
        end
        
        function res = sample(obj)
            res = zeros(1,obj.nPixels);
            for i = 1:obj.nPixels
                res(i) = obj.fitArray{i}.sample();
            end
        end
    end
    
end

