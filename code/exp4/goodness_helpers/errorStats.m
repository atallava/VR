classdef errorStats < handle
    %errorStats analyse error
        
    properties (SetAccess = private)
        % errorMat is num test poses x num params x num pixels
        % validMat is errorMat with nans replaced by 0
        errorMat
        validMask
        validMat
    end
    
    methods
        function obj = errorStats(errorMat)
            if nargin > 0
                obj.errorMat = errorMat;
                nanMask = isnan(obj.errorMat);
                obj.validMask = ~nanMask;
                obj.validMat = obj.errorMat;
                obj.validMat(nanMask) = 0;
            end
        end
        
        function res = getPixelParamME(obj)
            % collapse errors to parameters and pixels
            res = squeeze(sum(obj.validMat,1))/size(obj.validMask,1);
        end
        
        function [res,nOut] = getParamME(obj)
           % collapse errors to parameters
           nParams = size(obj.errorMat,2);
           res = zeros(1,nParams);
           nOut = 0;
           for i = 1:nParams
               mat = squeeze(obj.validMat(:,i,:));
               validIds = squeeze(obj.validMask(:,i,:));
               % throwing outliers
               outlierIds = errorStats.outlier1D(mat(validIds));
               mat(outlierIds) = 0;
               res(i) = sum(mat(:))/(sum(validIds(:))-sum(outlierIds(:)));
               nOut = nOut+sum(outlierIds(:));
           end
        end
        
        function res = getPixelME(obj)
           % collapse errors to pixels
           res = squeeze(sum(obj.validMat,1));
           res = squeeze(sum(res,1));
           res = res./sum(squeeze(sum(obj.validMask,1)),1);
        end
    end
    
    methods (Static = true)
        function outliers = outlierDiagnostic(dataMat,labels)
            %errorDiagnostic throws up possible outliers
            % labels is a cell array where labels{i} contains labels for the i-th
            % dimension of dataMat
            % outliers is an array of dimension nOutliers x dim of data containing
            % outlier coordinates
            
            if nargin < 2
                for i = 1:ndims(dataMat)
                    labels{i} = 1:size(dataMat,i);
                end
            end
            
            %{
            mu = mean(dataMat(:));
            sigma = std(dataMat(:));
            ids = find((dataMat >= mu+sigma) | (dataMat <= mu-sigma));
            %}
            
            uq = quantile(dataMat(:),0.75);
            qrange = iqr(dataMat(:));
            ids = find(dataMat > uq+1.5*qrange);
            nDims = length(labels);
            subs = cell(1,nDims);
            [subs{:}] = ind2sub(size(dataMat),ids);
            nOutliers = length(subs{1});
            outliers = zeros(nOutliers,nDims);

            temp = zeros(1,nDims);
            for i = 1:nOutliers
                for j = 1:nDims
                    temp(j) = labels{j}(subs{j}(i));
                end
                outliers(i,:) = temp;
            end

        end
        
         function ids = outlier1D(vec)
            %outlier1D return ids which could be outliers in 1D array vec
            % vec is an error vector, so only large errors are outliers
            f = 2;
            uq = quantile(vec,0.8);
            qrange = iqr(vec);
            ids = vec > uq+f*qrange;
         end
         
         function nll = getNll(paramArray,fitClass,data)
             %GETNLL
             %
             % nll = GETNLL(paramArray,fitClass,data)
             %
             % paramArray - Parameter array of size nParams x nPixels.
             % fitClass   - Handle to pdf class.
             % data       - NLL calculated on this data.
             %
             % nll        - Scalar.
             
             nll = [];
             nPixels = size(paramArray,2);
             inputStruct.choice = 'params';
             for i = 1:nPixels
                 inputStruct.vec = squeeze(paramArray(:,i));
                 pdfObject = fitClass(inputStruct);
                 nll = [nll pdfObject.negLogLike(data(i))];
             end
         end
    end
    
end

