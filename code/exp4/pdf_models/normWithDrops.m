classdef normWithDrops < handle & abstractPdf
    %normWithDrops fit a normal distribution + dropout probability to data
    
    properties (Constant = true)
        nParams = 3
        dx = 2e-3;
    end
    
    properties (SetAccess = private)
        mu
        sigma
        pZero
        nll       
    end
    
    methods
        function obj = normWithDrops(inputStruct)
            % inputStruct fields ('vec','choice')
            % 'choice' is 'raw' (default) or 'params'
            if nargin > 0
                if ~isfield(inputStruct,'choice')
                    inputStruct.choice = 'raw';
                end
                if strcmp(inputStruct.choice,'raw')
                    % fit to vec
                    obj.fitData(inputStruct.vec);
                else
                    % input is parameters
                    if length(inputStruct.vec) ~= 3
                        error('NEED 3 VALUES IF WANT TO INPUT PARAMETERS TO NORMWITHDROPS.');
                    end
                    obj.mu = inputStruct.vec(1);
                    if obj.mu < 0; obj.mu = 0; end
                    obj.sigma = inputStruct.vec(2);
                    if obj.sigma < 0; obj.sigma = 0; end
                    obj.pZero = inputStruct.vec(3);
                    if obj.pZero < 0; obj.pZero = 0; end
                    obj.nll = NaN;
                end
            end
        end
        
        function res = negLogLike(obj,data)
           % negative log likelihood of data
           if obj.pZero < 1
               if isnan(obj.sigma) || (obj.sigma == 0)
                   vec1 = (data == obj.mu)*(1-obj.pZero);
               else
                   temp = (data-obj.mu)/obj.sigma;
                   x2 = temp+normWithDrops.dx*0.5; x1 = temp-normWithDrops.dx*0.5;
                   vec1 = 0.5*(erf(x2/sqrt(2))-erf(x1/sqrt(2)))*(1-obj.pZero);
               end
               vec2 = (data == 0)*obj.pZero;
               res = -sum(log(vec1+vec2));
           else
               res = +(data == 0);
               res = -sum(log(res));
           end
           res = res/length(data);
        end
        
        function res = snap2PMF(obj,centers)
            % centers is a vector of equally spaced values
            % snap the pdf to a pmf about centers
            
            res = zeros(size(centers));
            binSize = centers(2)-centers(1);
            if obj.pZero < 1
                if isnan(obj.sigma) || obj.sigma == 0
                    res(findBinId(centers,obj.mu)) = 1;
                else
                    x2 = centers+binSize*0.5; x1 = centers-binSize*0.5;
                    x2 = (x2-obj.mu)/obj.sigma; x1 = (x1-obj.mu)/obj.sigma; 
                    res = 0.5*(erf(x2/sqrt(2))-erf(x1/sqrt(2)));
                end
            end
            res = res*(1-obj.pZero);
            id = findBinId(centers,0);
            res(id) = res(id)+obj.pZero;
            
            function id = findBinId(centers,x)
                flag = x <= centers+binSize*0.5 & x > centers-binSize*0.5;
                id = find(flag);
            end
        end
        
        function res = sample(obj,nSamples)
            % sample with current parameters
            if nargin < 2
                nSamples = 1;
            end
            res = zeros(1,nSamples);
            for i = 1:nSamples
                if rand < obj.pZero
                    res(i) = 0;
                else
                    if isnan(obj.sigma)
                        res(i) = obj.mu;
                    elseif isnan(obj.mu)
                        res(i) = 0;
                    else
                        res(i) = random('normal',obj.mu,obj.sigma);
                    end
                end
            end
        end
        
        function res = getParams(obj)
            res = [obj.mu obj.sigma obj.pZero];
        end        
    end
    
    methods (Access = private)        
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
                    obj.sigma = NaN;
                else
                    try
                        params = mle(data,'distribution','normal');
                    catch
                        error('FAILED TO FIT MODEL TO DATA.');
                    end
                    obj.mu = params(1);
                    obj.sigma = params(2);
                end
            else
                % all zero readings
                obj.mu = NaN;
                obj.sigma = NaN;
            end
            obj.nll = obj.negLogLike(data);
        end
    end
    
    methods (Static = true)
        function res = numParams()
            res = 3;
        end
    end
    
end

