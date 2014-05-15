classdef (Abstract) abstractPdf < handle
    %abstractPdf abstract class for modeling pdfs
    
    properties (Abstract, Constant = true)
        % nParams is the number of parameters in this model
        % dx is a step size
        nParams
        dx
    end
    
    methods (Abstract)
        negLogLike(obj,data)
        snap2PMF(obj,centers)
        sample(obj,nSamples)
        getParams(obj)
    end
    
end
