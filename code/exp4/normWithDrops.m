classdef normWithDrops < handle
    %normWithDrops fit a normal distribution + dropout probability to data
    
    properties (Constant = true)
        nParams = 3;
        dx = 1e-3;
    end
    
    properties (SetAccess = private)
        mu
        sigma
        pZero
        nll
       
    end
    
    methods
        function obj = normWithDrops(input,choice)
            % need an empty constructor for object arrays
            if nargin > 0
                if choice == 0
                    % fit to input
                    obj.fitData(input);
                else
                    % input is parameters
                    if length(input) ~= 3
                        error('NEED 3 VALUES IF CHOSE TO INPUT PARAMETERS TO NORMWITHDROPS');
                    end
                    obj.mu = input(1);
                    obj.sigma = input(2);
                    obj.pZero = input(3);
                    obj.nll = NaN;
                end
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
                    obj.sigma = NaN;
                else
                    try
                        params = mle(data,'distribution','normal');
                    catch
                        error('BAD DATA.');
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
        
        function res = negLogLike(obj,data)
           % negative log likelihood of data
           if obj.pZero < 1
               if isnan(obj.sigma) || (obj.sigma == 0)
                   vec1 = (data == obj.mu)*(1-obj.pZero);
               else
                   vec1 = pdf('normal',data,obj.mu,obj.sigma)*obj.dx*(1-obj.pZero);
               end
               vec2 = (data == 0)*obj.pZero;
               res = -sum(log(vec1+vec2));
           else
               res = +(data == 0);
               res = -sum(log(res));
           end
        end
        
        function res = snap2PMF(obj,centers)
            % centers is a vector of equally spaced values starting from
            % zero and ending at the maximum range value of a sensor
            % snap the pdf to a pmf about centers
            
            res = zeros(size(centers));
            binSize = centers(2)-centers(1);
            if obj.pZero == 1
                res(1) = 1;
                return;
            else
                if isnan(obj.sigma)
                    index = floor(obj.mu/binSize);
                    res(index) = 1;
                else
                    prob = pdf('normal',centers,obj.mu,obj.sigma);
                    % assuming small bin sizes
                    % assuming negligible probability mass outside centers
                    res = prob*binSize;
                end
                % should sum to one under assumptions, but extra check
                res = res/sum(res);
                res = res*(1-obj.pZero);
                res(1) = res(1)+obj.pZero;
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
    
end

