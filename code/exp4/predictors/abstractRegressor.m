classdef (Abstract) abstractRegressor < handle
    %abstractRegressor base class for regressors
    
    properties (SetAccess = protected)
        % XTrain is num observations x dimX, training input
        % YTrain is num observations x dimY, training output
        % XSpaceSwitch is a switch object
        % XLast is num queries x dimX, cache of last query
        % YLast is num queries x dimY, cache of last query
        XTrain
        YTrain
        XSpaceSwitch
        XLast
        YLast
    end
    
    methods (Abstract)
        res = predict(obj,X)
    end
    
    methods
        function removeSwitchedTrainingData(obj)
            flag = obj.XSpaceSwitch.switchX(obj.XTrain);
            dimY = size(obj.YTrain,2);
            obj.YTrain(flag,:) = nan(sum(flag),dimY);
        end
        
        function cleanTrainingData(obj)
            % Remove training data containing nans in XTrain
            throwIds = isnan(obj.XTrain);
            throwIds = logical(sum(throwIds,2));
            obj.XTrain(throwIds,:) = [];
            obj.YTrain(throwIds,:) = [];
        end
    end
    
end

