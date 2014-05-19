classdef parametricRegressor < handle & abstractRegressor
    %parametricRegressor simple class for parametric regression over multiple parameters
           
    properties (SetAccess = private)
        % nTargets is the number of output values
        % models is a cell array of NonLinearModels, one model for each
        % target
        XTrain
        YTrain
        nTargets
        models
        XLast
        YLast        
    end
    
    methods
        function obj = parametricRegressor(inputData)
            % inputData fields ('XTrain','YTrain','fnForms','weights0')
            % empty constructor to allow object arrays
            if nargin > 0
                obj.XTrain = inputData.XTrain;
                obj.YTrain = inputData.YTrain;
                obj.nTargets = size(obj.YTrain,2);
                obj.fitModels2TrainingData(inputData.fnForms,inputData.weights0);
            end
        end
   
        function Y = predict(obj,X)
            if isempty(obj.models)
                error('RUN REGRESS BEFORE PREDICT!');
            end
            nQueries = size(X,1);
            Y = zeros(nQueries,obj.nTargets);
        
            for i = 1:obj.nTargets
                if ~parametricRegressor.isModel(obj.models{i})
                    % no model to predict
                    Y(:,i) = NaN(nQueries,1);
                    continue;
                else
                    [y, ~] = predict(obj.models{i},X);
                    if isrow(y)
                        y = y';
                    end
                    Y(:,i) = y;
                end
            end      
            obj.XLast = X;
            obj.YLast = Y;
        end
    end
    
    methods (Access = private)
        function obj = fitModels2TrainingData(obj,fn,weights0)
            % fn is a cell of function handles of size dimY
            % weights0 is a cell of seed weights of size dimY
            
            obj.models = cell(1,obj.nTargets);
            for i = 1:obj.nTargets
                if all(isnan(obj.YTrain(:,i)))
                    % no data points available to fit model
                    obj.models{i} = NaN;
                    continue;
                else
                    obj.models{i} = NonLinearModel.fit(obj.XTrain,obj.YTrain(:,i),fn{i},weights0{i});
                end
                
                % this is a R2013b function 
                % obj.models{i} = fitnlm(obj.XTrain,obj.YTrain(:,i),fn{i},weights0{i}); 
            end
        end
    end
    
    methods (Static = true)
        function res = isModel(model)
            res = false;
            if isa(model,'NonLinearModel')
                res = true;
            end
        end
    end
    
end

