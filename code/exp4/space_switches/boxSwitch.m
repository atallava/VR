classdef boxSwitch < abstractSwitch & handle
    %boxSwitch if X is not in box, assign a value switchY

    properties (SetAccess = private)
        % XRanges is 2 x dimX
        XRanges
        switchY
        dimX
    end

    methods
        function obj = boxSwitch(inputStruct)
            % inputStruct fields ('XRanges','switchY')
            if isfield(inputStruct,'XRanges')
                obj.XRanges = inputStruct.XRanges;
            else
                error('XRANGES NOT INPUT.');
            end
            if isfield(inputStruct,'switchY')
                obj.switchY = inputStruct.switchY;
            else
                error('SWITCHY NOT INPUT.');
            end
            obj.dimX = size(obj.XRanges,1);
        end
        
        function res = switchX(obj,X)
            % X is numX x dimX
            nX = size(X,1);
            res = zeros(nX,1);
            for i = 1:nX
                if all(X(i,:) >= obj.XRanges(1,:) & X(i,:) <= obj.XRanges(2,:))
                    continue;
                else
                    res(i) = 1;
                end
            end
            res = logical(res);
        end
    end
end
