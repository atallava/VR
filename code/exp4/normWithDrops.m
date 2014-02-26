classdef normWithDrops < handle
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
        function obj = normWithDrops(input,choice)
            % need an empty constructor for object arrays
            if nargin > 0
                if choice == 0
                    % fit to input
                    obj.fitData(input);
                else
                    % input is parameters
                    if length(input) ~= 3
                        warning('NEED 3 VALUES IF CHOSE TO INPUT PARAMETERS TO NORMWITHDROPS');
                    end
                    obj.mu = input(1);
                    obj.sigma = input(2);
                    obj.pZero = input(3);
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
                    obj.sigma = 0;
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
        
        function res = negLogLike(obj,data)
           % negative log likelihood of data
           if obj.pZero < 1
               if obj.sigma ~= 0
                   vec1 = pdf('normal',data,obj.mu,obj.sigma)*(1-obj.pZero);
               else
                   vec1 = (data == obj.mu)*(1-obj.pZero);
               end
               vec2 = (data == 0)*obj.pZero;
               res = -log(sum(vec1+vec2));
           else
               res = -log(sum(data == 0));
           end
        end
        
        function res = snap2PMF(obj,centers)
            % centers is a vector of equally spaced values starting from
            % zero and ending at the maximum range value of a sensor
            % snap the pdf to a pmf about centers
            
            binSize = centers(2)-centers(1);
            prob = pdf('normal',centers,obj.mu,obj.sigma);
            % assuming small bin sizes
            % assuming negligible probability mass outside centers
            res = prob*binSize;
            % should sum to one under assumptions, but extra check
            res = res/norm(res); 
            res = res*(1-obj.pZero);
            res(1) = res(1)+obj.pZero;           
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
                    res(i) = random('normal',obj.mu,obj.sigma);
                end
            end
        end
        
        function res = getParams(obj)
            res = [obj.mu obj.sigma obj.pZero];
        end        
    end
    
end

