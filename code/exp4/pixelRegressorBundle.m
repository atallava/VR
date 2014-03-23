classdef pixelRegressorBundle < handle
    %pixelBundleRegressor deals with regression over a collection of pixels
        
    properties (SetAccess = private)
        % XTrain is num observations x dimX, training input
        % YTrain is num observations x dimY x num pixels, training output
        % regClass is a handle to the regressor class to be used on each
        % pixel
        % poseTransf is an instance of a class that transforms poses
        % regressorArray is a cell of length nPixels, one for each
        % pixel
        % XLast is num queries x dimX, cache of last query
        % YLast is num queries x dimY x numPixels, cache of last query
        XTrain
        YTrain
        pixelIds
        nPixels
        poseTransf
        regClass
        regressorArray
        XLast
        YLast 
    end
    
    methods
        function obj = pixelRegressorBundle(inputData)
            % inputData fields ('XTrain', 'YTrain', 'poseTransf', 'pixelIds',
            % 'regClass', <regressor specific fields>)
            
            obj.XTrain = inputData.XTrain;
            obj.YTrain = inputData.YTrain;
            if isfield(inputData,'poseTransf')
                obj.poseTransf = inputData.poseTransf;
            end
            obj.regClass = inputData.regClass;
            obj.pixelIds = inputData.pixelIds;
            obj.nPixels = length(obj.pixelIds);
            obj.fillPixelRegressorArray(inputData);
        end
        
        function obj = fillPixelRegressorArray(obj,inputData)
            obj.regressorArray = cell(1,obj.nPixels);
            if isempty(obj.poseTransf)
                XTransf = repmat(obj.XTrain,[1,1,obj.nPixels]);
            else
                XTransf = obj.poseTransf.transform(obj.XTrain);
            end
            for i = 1:obj.nPixels
                tempInput = inputData;
                tempInput.XTrain = XTransf(:,:,i);
                tempInput.YTrain = obj.YTrain(:,:,i);
                obj.regressorArray{i} = obj.regClass(tempInput);
            end
        end
        
        function Y = predict(obj,X)
            nQueries = size(X,1);
            Y = zeros(nQueries,size(obj.YTrain,2),obj.nPixels);
            if isempty(obj.poseTransf)
                XTransf = repmat(X,[1,1,obj.nPixels]);
            else
                XTransf = obj.poseTransf.transform(X);
            end
            
            for i = 1:obj.nPixels
                Y(:,:,i) = obj.regressorArray{i}.predict(XTransf(:,:,i));
            end
            obj.XLast = X;
            obj.YLast = Y;
        end
        
        % TODO: fill in
        function res = getMSE(obj)
            % return MSE on training data
            res = 0;
        end
    end
    
end

