classdef rangeImage < handle
    
    properties (Constant)
        maxUsefulRange = 4.0;
        minUsefulRange = 0.05;
        maxRangeForTarget = 1.0;
    end
    
    properties (Access = public)
        rArray = [];
        thArray = [];
        xArray = [];
        yArray = [];
        npix;
        im_resolution = 0.01;
        im_range = 4.0;
        im_steps = 800;
        im;
    end
    
    methods 
        function obj = rangeImage(ranges,skip,cleanFlag)
            dth = pi/180;
            if nargin == 3
                count = 0;
                for i = 1:skip:length(ranges)
                    count = count+1;
                    obj.rArray(count) = ranges(i);
                    obj.thArray(count) = (i-1)*dth;
                    obj.xArray(count) = ranges(i)*cos(obj.thArray(count));
                    obj.yArray(count) = ranges(i)*sin(obj.thArray(count));
                end
                obj.npix = count;
                if cleanFlag
                    obj.removeBadPoints;
                end
            end
        end
        
        function obj = removeBadPoints(obj)
            ids = find(obj.rArray < obj.minUsefulRange | obj.rArray > obj.maxUsefulRange);
            obj.rArray(ids) = []; 
            obj.thArray(ids) = [];
            obj.xArray(ids) = [];
            obj.yArray(ids) =[];
            obj.npix = length(obj.rArray);
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
            n = obj.npix;
        end
        
        function res = indexAdd(obj,a,b)
           res = mod((a-1)+b,obj.npix)+1; 
        end
            
        function res = inc(obj,in)
            res = obj.indexAdd(in,1);
        end
        
        function res = dec(obj,in)
            res = obj.indexAdd(in,-1);
        end
        
        function obj = createBWImage(obj,range,resolution)
            % convert range readings to a BW image
            if nargin > 1
                obj.im_range = range;
                obj.im_resolution = resolution;
                obj.im_steps = 2*ceil(obj.im_range/obj.im_resolution);
            end            
            obj.im = zeros(obj.im_steps);
            rows = obj.im_steps*0.5+ceil(obj.yArray/obj.im_resolution);
            rows = obj.im_steps+1-rows; % since in an image rows increase downwards
            cols = obj.im_steps*0.5+ceil(obj.xArray/obj.im_resolution);          
            ids = sub2ind(size(obj.im),rows,cols);
            obj.im(ids) = 1;
            obj.im = mat2gray(obj.im);
        end
        
        function id = getIDFromRC(obj,row,col)
            % get index of point given row and column in obj.im
            row = obj.im_steps+1-row;
            xlim = [obj.im_resolution*(col-obj.im_steps*0.5-1) obj.im_resolution*(col-obj.im_steps*0.5)];
            ylim = [obj.im_resolution*(row-obj.im_steps*0.5-1) obj.im_resolution*(row-obj.im_steps*0.5)];
            xid = find(obj.xArray > xlim(1) &  obj.xArray <= xlim(2));                       
            yid = find(obj.yArray > ylim(1) &  obj.yArray <= ylim(2));
            id = intersect(xid,yid);
            % return first index if there are multiple
            id = id(1);
        end
    end
end
    

