classdef pixelRegressorBundle < handle
    %pixelBundleRegressor deals with regression over a collection of pixels
        
    properties %(SetAccess = private)
        % XTrain is num observations x dimX, training input
        % YTrain is num observations x dimY x num pixels, training output
        % regClass is a handle to the regressor class to be used on each
        % pixel
        % inputPoseTransf is an instance of a class that transforms poses
        % regressorArray is a cell of length nPixels, one for each
        % pixel
        % XLast is num queries x dimX, cache of last query
        % YLast is num queries x dimY x numPixels, cache of last query
        XTrain
        YTrain
        dimY
        nPixels
        inputPoseTransf
        regClass
        regressorArray
        XLast
        YLast 
    end
    
    methods
        function obj = pixelRegressorBundle(inputStruct)
            % inputStruct fields ('XTrain', 'YTrain', 'inputPoseTransf',
            % 'regClass', <regressor specific fields>)
            
            obj.XTrain = inputStruct.XTrain;
            obj.YTrain = inputStruct.YTrain;
            if ndims(obj.YTrain) == 2 %#ok<ISMAT>
                obj.dimY = 1;
                obj.YTrain = reshape(obj.YTrain,[size(obj.YTrain,1) 1 size(obj.YTrain,2)]);
            else
                obj.dimY = size(obj.YTrain,2);
            end
            if isfield(inputStruct,'inputPoseTransf')
                obj.inputPoseTransf = inputStruct.inputPoseTransf;
            end
            obj.regClass = inputStruct.regClass;
            obj.nPixels = size(obj.YTrain,3);
            obj.fillPixelRegressorArray(inputStruct);
        end
        
        function Y = predict(obj,X,queryMap)
            % if not supplied, assumed to be working in the same map as
            % contained in obj.inputPoseTransf
            queryPoseTransf = obj.inputPoseTransf;
            if nargin > 2
                queryPoseTransf.setMap(queryMap);
            end
            
            nQueries = size(X,1);
            Y = zeros(nQueries,size(obj.YTrain,2),obj.nPixels);
            if isempty(obj.inputPoseTransf)
                XTransf = repmat(X,[1,1,obj.nPixels]);
            else
                XTransf = queryPoseTransf.transform(X);
            end
            
            for i = 1:obj.nPixels
                Y(:,:,i) = obj.regressorArray{i}.predict(XTransf(:,:,i));
            end
            obj.XLast = X;
            obj.YLast = Y;
        end
    end
    
    methods (Access = private)
       function obj = fillPixelRegressorArray(obj,inputStruct)
            obj.regressorArray = cell(1,obj.nPixels);
            if isempty(obj.inputPoseTransf)
                XTransf = repmat(obj.XTrain,[1,1,obj.nPixels]);
            else
                XTransf = obj.inputPoseTransf.transform(obj.XTrain);
            end
            %naive, indpendent pixels
            
            for i = 1:obj.nPixels
                tempInput = inputStruct;
                tempInput.XTrain = XTransf(:,:,i);
                tempInput.YTrain = obj.YTrain(:,:,i);
                obj.regressorArray{i} = obj.regClass(tempInput);
            end
            
            %other end, throw everything together
            %{
            bigX = []; bigY = [];
            for i = 1:obj.nPixels
                bigX = [bigX; XTransf(:,:,i)];
                bigY = [bigY; obj.YTrain(:,:,i)];
            end
            tempInput = inputStruct;
            tempInput.XTrain = bigX;
            tempInput.YTrain = bigY;
            tempObj = obj.regClass(tempInput);
            obj.regressorArray(:) = {tempObj};
            %}
       end
    end
    
end

