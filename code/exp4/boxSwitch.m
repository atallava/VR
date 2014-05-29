classdef boxSwitch < abstractSwitch & handle
    %boxSwitch if X is not in box, assign a value switchY

    properties (SetAccess = private)
        % XRanges is 2 x dimX
        XRanges
        switchY
        dimX
    end

    methods
        function obj = boxSwitch(inputData)
            % inputData fields ('XRanges','switchY')
            if isfield(inputData,'XRanges')
                obj.XRanges = inputData.XRanges;
            else
                error('XRANGES NOT INPUT.');
            end
            if isfield(inputData,'switchY')
                obj.switchY = inputData.switchY;
            else
                error('SWITCHY NOT INPUT.');
            end
            obj.dimX = size(obj.XRanges,1);
        end
        
        function res = switchX(obj,X)
            nX = size(X,1);
            res = zeros(nX,1);
            for i = 1:nX
                if any(X(i,:) < obj.XRanges(1,:)) || any(X(i,:) > obj.XRanges(2,:))
                    res(i) = 1;
                end
            end
            res = logical(res);
        end
    end
end
