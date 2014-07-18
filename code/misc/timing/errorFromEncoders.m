classdef errorFromEncoders < handle
     
    properties (Constant = true)
        p = [-0.0295, 0.1937, 0.0283];
    end
    
    methods
        function obj = errorFromEncoders()
        end

        function res = getError(obj,n,tEnc)
            res = n*polyval(errorFromEncoders.p,tEnc);
        end
    end
    
end

