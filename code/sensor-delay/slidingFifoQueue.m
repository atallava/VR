classdef slidingFifoQueue < handle
    %NOTE: different from neato_matlab/ implementation in that queue can
    %have a user-specified second direction
    
    %slidingFifoQueue A quick and dirty FIFO ques done with short vectors
    %so that you can run interp1 on the result to interpolate in time.
    %Intended to be used for modelling delays in real-time system. The
    %length of the queue should be small for performance reasons.
    
    % interp1 requires that the "x" array be monotone and have unique
    % values in it. That means this que has to grow to some length by
    % adding at the right and then start throwing data out the left.
    
    properties(Constant)
    end
    
    properties(Access = private)
        maxElements;
        numReturns;
    end
    
    properties(Access = public)
        que;
    end
    
    methods(Static = true)
        
    end
    
    methods(Access = private)
         
    end
            
    methods(Access = public)
        
        function obj = slidingFifoQueue(maxElements,numReturns)
        % Construct a slidingFifoQueue.
            if  nargin > 0
                obj.maxElements = maxElements;
                obj.que = [];
                obj.numReturns = 1;
            end
            if nargin > 1
               obj.numReturns = numReturns;
            end
        end
        
        function add(obj,element)
            if ~isrow(element)
                err = MException('AddErr:Format','Input must be a row.');
                throw(err);
            elseif numel(element) ~= obj.numReturns
                err = MException('AddErr:NumReturns',sprintf('Input must have length %d.',obj.numReturns));
                throw(err)
            end
        % Add an object at the right of the queue and slide to the left.
            if(length(obj.que) == obj.maxElements)
                obj.que(1:end-1,:) = obj.que(2:end,:);
                obj.que(end,:) = element;
            else
                obj.que(end+1,:) = element;
            end
            
        end       
    end
end