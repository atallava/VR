classdef rangeImage < handle
    %rangeImage class for handling range scans
        
    properties (Constant)
        maxUsefulRange = 4.5;
        minUsefulRange = 0.05;
        maxRangeForTarget = 1.0;
    end
    
    properties (Access = public)
        rArray = [];
        thArray = deg2rad(0:359);
        xArray = [];
        yArray = [];
        nPix;
        im_resolution = 0.01;
        im_range = 4.5;
        im;
    end
    
    methods 
        function obj = rangeImage(inputData)
            % inputData fields ('ranges','bearings','cleanup')
            % default (,deg2rad(0:359),0)
            if isfield(inputData,'bearings')
                obj.thArray = inputData.bearings;
            else
                obj.thArray = deg2rad(0:359);
            end
            obj.rArray = inputData.ranges;
            if iscolumn(obj.rArray)
                obj.rArray = obj.rArray';
            end
            obj.nPix = length(obj.rArray);
            obj.xArray = obj.rArray.*cos(obj.thArray);
            obj.yArray = obj.rArray.*sin(obj.thArray);
            if isfield(inputData,'cleanup')
                if inputData.cleanup
                    obj.cleanup();
                end
            end
        end
        
        function obj = cleanup(obj,minUsefulRange,maxUsefulRange)
            % throw away points outside [minUsefulRange maxUsefulRange]
            if nargin == 1
                ids = find(obj.rArray < obj.minUsefulRange | obj.rArray > obj.maxUsefulRange);
            else
                ids = find(obj.rArray < minUsefulRange | obj.rArray > maxUsefulRange);
            end
            obj.rArray(ids) = []; 
            obj.thArray(ids) = [];
            obj.xArray(ids) = [];
            obj.yArray(ids) =[];
            obj.nPix = length(obj.rArray);
        end
        
        function hf = plotRvsTh(obj,maxRange)
            ids = find(obj.rArray <= maxRange);
            hf = figure;
            scatter(obj.thArray(ids), obj.rArray(ids), 10);
        end
        
        function hf = plotXvsY(obj,maxRange)
            if nargin < 2
                maxRange = obj.maxUsefulRange;
            end
            ids = find(obj.rArray <= maxRange);
            hf = figure;
            scatter(obj.xArray(ids), obj.yArray(ids), 10);
            axis equal; 
            xlabel('x');
            ylabel('y');
            dcm_obj = datacursormode(hf);
            set(dcm_obj,'UpdateFcn',@updateWithId);

            function txt = updateWithId(~,event_obj)
                pos = get(event_obj,'Position');
                x_coord = pos(1); y_coord = pos(2);
                x_id = find(obj.xArray == x_coord);
                y_id = find(obj.yArray == y_coord);
                id = intersect(x_id,y_id);
                txt = {['x: ',num2str(x_coord)],...
                    ['y: ',num2str(y_coord)],...
                    ['id: ',num2str(id)]};
            end
        end
        
        function n = numPixels(obj)
            n = obj.nPix;
        end
        
        function res = indexAdd(obj,a,b)
           res = mod((a-1)+b,obj.nPix)+1; 
        end
            
        function res = inc(obj,in)
            res = obj.indexAdd(in,1);
        end
        
        function res = dec(obj,in)
            res = obj.indexAdd(in,-1);
        end
        
        function obj = createBWImage(obj,range,resolution)
            % convert range readings to a BW image
            % ranges need to be within maxUsefulRange
            if nargin > 1
                obj.im_range = range;
                obj.im_resolution = resolution;
            end
            steps = 2*ceil(obj.im_range/obj.im_resolution);
            obj.im = zeros(steps);
            rows = steps*0.5+ceil(obj.yArray/obj.im_resolution);
            rows = steps+1-rows; % since in an image rows increase downwards
            cols = steps*0.5+ceil(obj.xArray/obj.im_resolution);  
            ids = sub2ind(size(obj.im),rows,cols);
            obj.im(ids) = 1;
            obj.im = mat2gray(obj.im);
        end
     
        function id = getIDFromRC(obj,row,col)
            % get index of point given row and column in obj.im
            steps = size(obj.im,1);
            row = steps+1-row;
            xlim = [obj.im_resolution*(col-steps*0.5-1) obj.im_resolution*(col-steps*0.5)];
            ylim = [obj.im_resolution*(row-steps*0.5-1) obj.im_resolution*(row-steps*0.5)];
            xid = find(obj.xArray > xlim(1) &  obj.xArray <= xlim(2));                       
            yid = find(obj.yArray > ylim(1) &  obj.yArray <= ylim(2));
            id = intersect(xid,yid);
        end
        
        function pcd = getPCD(obj)
            pcd = [obj.xArray; obj.yArray; zeros(1,length(obj.xArray))];
        end
        
        function pts = getPts(obj)
            pts = [obj.xArray; obj.yArray];
        end
        
        function pts = getPtsHomogeneous(obj)
            pts = [obj.xArray; obj.yArray; ones(1,obj.nPix)];
        end
    end
end
    

