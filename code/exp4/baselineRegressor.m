classdef baselineRegressor < handle & abstractRegressor
    %baselineRegressor predict parameters using a formula
    
    properties (SetAccess = private)
        % nParams is number of output parameters
        % K is a constant used to calculate sigma
        nParams = 3
        K = 1e-3
    end
    
    methods
        function obj = baselineRegressor(inputData)
            % inputData fields ('K')
            if nargin > 0
                if isfield(inputData,'K')
                    obj.K = inputData.K;
                end
            end
        end
        
        function Y = predict(obj,X)
            nQueries = size(X,1);
            Y = zeros(nQueries,obj.nParams);
            Y(:,1) = X(:,1);
            Y(:,2) = (X(:,1).^2)./cos(X(:,2));
            Y(:,2) = obj.K*Y(:,2);
            obj.XLast = X;
            obj.YLast = Y;
        end
    end
    
end


