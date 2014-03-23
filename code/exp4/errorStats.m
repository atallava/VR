classdef errorStats < handle
    %errorStats analyse error
        
    properties
        % errorMat is num test poses x num params x num pixels
        % validMat is errorMat with nans replaced by 0
        errorMat
        validMask
        validMat
    end
    
    methods
        function obj = errorStats(errorMat)
            obj.errorMat = errorMat;
            nanMask = isnan(obj.errorMat);
            obj.validMask = ~nanMask;
            obj.validMat = obj.errorMat;
            obj.validMat(nanMask) = 0;
        end
        
        function res = getPixelParamRMSE(obj)
            % collapse errors to parameters and pixels
            res = squeeze(sum(obj.errorMat,1))/size(obj.errorMat,1);
            res = sqrt(res);
        end
        
        function res = getParamRMSE(obj)
           % collapse errors to parameters
           res = squeeze(sum(obj.validMat,1));
           res = squeeze(sum(res,2));
           res = res./sum(squeeze(sum(obj.validMask,1)),2);
           res = sqrt(res); 
        end
        
        function res = getPixelRMSE(obj)
           % collapse errors to pixels
           res = squeeze(sum(obj.validMat,1));
           res = squeeze(sum(res,1));
           res = res./sum(squeeze(sum(obj.validMask,1)),1);
           res = sqrt(res);
        end
    end
    
    methods (Static = true)
        function outliers = outlierDiagnostic(dataMat,labels)
            %errorDiagnostic throws up possible outliers
            % labels is a cell array where labels{i} contains labels for the i-th
            % dimension of dataMat
            % outliers is an array of dimension nOutliers x dim of data containing
            % outlier coordinates

            mu = mean(dataMat(:));
            sigma = std(dataMat(:));
            ids = find((dataMat >= mu+sigma) | (dataMat <= mu-sigma));
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
    end
    
end

