classdef pdfBundle < handle
    %pdfBundle fit parameters to range data at different poses and pixels
        
    properties (SetAccess = private)
        % fitClass is a handle to the fitting class
        % fitArray is a num pixels length array of fitClass instances
        % data is a cell array of size num poses x num pixels
        % nParams is number of params used by fitName
        % paramArray is num poses x num parameters x num pixels
        % nllArray is num poses x num pixels, array of negative log
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
        function obj = pdfBundle(inputStruct)
            % inputStruct fields ('fitClass','data')
            obj.fitClass = inputStruct.fitClass;
            obj.data = inputStruct.data;
            obj.nPixels = size(obj.data,2);
            tempObj = obj.fitClass(struct('vec',[]));
            obj.nParams = tempObj.nParams;
            obj.fillParamArray();
        end
                 
        function res = sample(obj)
            res = zeros(1,obj.nPixels);
            for i = 1:obj.nPixels
                res(i) = obj.fitArray{i}.sample();
            end
        end
        
        function markOutliers(obj)
           %markOutliers if nll for data is high, set params to nan
           for i = 1:size(obj.paramArray,1)
               ids = errorStats.outlier1D(obj.nllArray(i,:));
               if isempty(ids)
                   continue;
               end
               obj.paramArray(i,:,ids) = nan;
           end
        end
    end
    
    methods (Access = private)
        function fillParamArray(obj)
            nPoses = size(obj.data,1);
            obj.paramArray = zeros(nPoses,obj.nParams,obj.nPixels);
            obj.fitArray = cell(1,obj.nPixels);
            obj.nllArray = zeros(nPoses,obj.nPixels);
            for i = 1:nPoses
                for j = 1:obj.nPixels
                    obj.fitArray{i} = obj.fitClass(struct('vec',obj.data{i,j}));
                    obj.paramArray(i,:,j) = obj.fitArray{i}.getParams();
                    obj.nllArray(i,j) = obj.fitArray{i}.nll;
                end
            end
        end
    end
    
end

