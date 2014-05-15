classdef (Abstract) abstractRegressor < handle
    %abstractRegressor base class for regressors
    
    properties (Abstract, SetAccess = private)
        % XTrain is num observations x dimX, training input
        % YTrain is num observations x dimY, training output
        % XLast is num queries x dimX, cache of last query
        % YLast is num queries x dimY, cache of last query
        XTrain
        YTrain
        XLast
        YLast
    end
    
    methods (Abstract)
        res = predict(obj,X)
    end
    
end

