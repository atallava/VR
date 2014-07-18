classdef errorAfterScanMatch < handle
        
    properties (Constant = true)
        timePerIteration = 0.09;
        largeError = 10;
    end
    
    properties (SetAccess = private)
        eIn
        numIter
        eOut
    end
    
    methods
        function obj = errorAfterScanMatch()
            load calibration_scan_match_errors;
            obj.eIn = [data.errorIn];
            obj.numIter = [data.refinerIter];
            obj.eOut = [data.errorOut];
        end
       
        function res = getError(obj,tProcLaser,errIn)
            nIter = ceil(tProcLaser/obj.timePerIteration);
            res = griddata(obj.numIter,obj.eIn,obj.eOut,nIter,errIn);
            if errIn == 0
                res = 0;
            elseif errIn > max(obj.eIn)
                res = errorAfterScanMatch.largeError;
            end
            if nIter < min(obj.numIter)
                res = errorAfterScanMatch.largeError;
            elseif nIter > max(obj.numIter)
                res = griddata(obj.numIter,obj.eIn,obj.eOut,max(obj.numIter),errIn);
            end            
        end
    end
    
end

