classdef fitNormWithDrops < handle
    % fit a normal distribution + dropout probability to data
    
    properties (Constant = true)
        nParams = 3;
    end
    
    properties (SetAccess = private)
        mu
        sigma
        pZero
       
    end
    
    methods
        function obj = fitNWithDrops(data)
            % need an empty constructor for object arrays
            if nargin > 0
                obj.fitData(data);
            end
        end
        
        function obj = fitData(obj,data)
            nData = length(data);
            zeroIds = find(data == 0);
            obj.pZero = length(zeroIds)/nData;
            if obj.pZero < 1
                data(zeroIds) = [];
                if length(data) == 1
                    % only a single data point available
                    % set this to the mean
                    obj.mu = data(1);
                    obj.sigma = [];
                    return;
                end
                try
                    params = mle(data,'distribution','normal');
                catch
                   warning('BAD DATA');
                end
                obj.mu = params(1);
                obj.sigma = params(2);
            end
        end
        
        function res = getParams(obj)
            res = [obj.mu obj.sigma obj.pZero];
        end
    end
    
end

