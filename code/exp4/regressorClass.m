classdef regressorClass < handle
    % simple class for regression and prediction over multiple parameters
    % of interest. independent regressor for each parameter
        
    properties (SetAccess = private)
        nTargets
        models
    end
    
    methods
        function obj = regressorClass(nTargets)
            % empty constructor to allow object arrays
            if nargin > 0
                obj.nTargets = nTargets;
            end
        end
        
        function obj = regress(obj,fn,X,Y,weights0)
            % fn is a cell of function handles, one for each target
            % X is the data matrix, observations x input dimension
            % Y is the output matrix, observations x output dimension
            % weights0 is a cell of seed weights, one for each target
            
            for i = 1:obj.nTargets
                if all(isnan(Y(:,i)))
                    % no data points available to fit model
                    obj.models{i} = NaN;
                    continue;
                else
                    obj.models{i} = NonLinearModel.fit(X,Y(:,i),fn{i},weights0{i});
                end
                
                % this is a R2013b function 
                % obj.models{i} = fitnlm(X,Y(:,i),fn{i},weights0{i}); 
            end
        end
        
        function Y = predict(obj,X)
            % X is test points x input dimension
            % Y is test points x nTargets
            if isempty(obj.models)
                warning('RUN REGRESS BEFORE PREDICT');
            end
            
            Y = zeros(size(X,1),obj.nTargets);
            for i = 1:obj.nTargets
                if ~isa(obj.models{i},'NonLinearModel')
                    % no model to predict
                    Y(:,i) = NaN(size(X,1),1);
                    continue;
                else
                    [y, ~] = predict(obj.models{i},X);
                    if isrow(y)
                        y = y';
                    end
                    Y(:,i) = y;
                end
            end
                
        end
    end
    
end

