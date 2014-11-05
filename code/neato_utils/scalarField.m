classdef scalarField < handle
        
    properties (SetAccess = private)
        ranges
        nBins
        stepsize
        field
    end
    
    methods
        function obj = scalarField(inputData)
            % inputData fields ('ranges' 'nBins','initVal')
            % default (,,0)
            obj.ranges = inputData.ranges;
            obj.nBins = inputData.nBins;
            obj.stepsize = (obj.ranges(2,:)-obj.ranges(1,:))./obj.nBins;
            obj.field = ones(obj.nBins);
            if isfield(inputData,'initVal')
                obj.field = obj.field*inputData.initVal;
            else
                obj.field = obj.field*0;
            end
        end
        
        function set(obj,coords,val)
            if ~obj.isInBounds(coords)
                error('COORDINATES NOT IN BOUNDS.');
            end
            ids = obj.coordsToIds(coords);
            obj.field(ids(1),ids(2)) = val;
        end
        
        function res = get(obj,coords)
            if ~obj.isInBounds(coords)
                error('COORDINATES NOT IN BOUNDS.');
            end
            ids = obj.coordsToIds(coords);
            res = obj.field(ids(1),ids(2));
        end
        
        function res = isInBounds(obj,coords)
            res = 1;
            if any(coords > obj.ranges(2,:))
                res = 0;
                return;
            end
            if any(coords < obj.ranges(1,:))
                res = 0;
                return;
            end
        end
        
        function res = coordsToIds(obj,coords)
            if ~obj.isInBounds(coords)
                error('COORDINATES NOT IN BOUNDS.');
            end
            coords = coords-obj.ranges(1,:);
            res = ceil(coords./obj.stepsize);
        end
        
        function res = idsToCoords(obj,ids)
            res = (ids-0.5).*obj.stepsize;
            res = res+obj.ranges(1,:);
        end
    end
    
end

