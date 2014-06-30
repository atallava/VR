classdef laserHistory < handle
    %laserHistory store laser values in an array
        
    properties
        rangeArray
        intensityArray
        tArray
        update_count
        listenerHandle
        rob
        bearings
        hfig
        hplot
        plot_flag
    end
    
    methods
        function obj = laserHistory(rob)
            if ~isfield(rob.laser.data,'header')
                error('LASER MUST BE ON');
            end
            obj.rob = rob;
            obj.rangeArray = cell(0);
            obj.intensityArray = cell(0);
            obj.tArray = [];
            obj.update_count = 0;
            obj.bearings = deg2rad(0:359);
            obj.hfig = figure; obj.hplot = plot(0,0,'.'); 
            axis equal; xlabel('x'); ylabel('y'); set(obj.hfig,'visible','off'); 
            obj.plot_flag = 0;
            obj.listenerHandle = addlistener(rob.laser,'OnMessageReceived',@(src,evt) laserHistory.laserEventResponse(src,evt,obj));
        end
        
        function obj = Reset(obj)
            obj.listenerHandle.delete;
            pause(0.01);
            obj.rangeArray = cell(0);
            obj.intensityArray = cell(0);
            obj.tArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(obj.rob.laser,'OnMessageReceived',@(src,evt) encHistory.laserEventResponse(src,evt,obj));
        end
        
        function obj = togglePlot(obj)
            if obj.plot_flag
                set(obj.hfig,'visible','off');
            else
                set(obj.hfig,'visible','on');
            end
            obj.plot_flag = ~obj.plot_flag;
        end
        
        function obj = updatePlot(obj)
            x = obj.rangeArray{end}.*cos(obj.bearings);
            y = obj.rangeArray{end}.*sin(obj.bearings);
            set(obj.hplot,'XData',x,'YData',y);
        end
        
        function obj = stopListening(obj)
            obj.listenerHandle.delete;
        end
    end
            
    methods (Static)
        function laserEventResponse(src,evt,obj)
            obj.update_count = obj.update_count+1;
            obj.tArray(obj.update_count) = evt.data.header.stamp.secs + (evt.data.header.stamp.nsecs*1e-9);
            obj.rangeArray{obj.update_count+1} = evt.data.ranges;
            %obj.intensityArray{obj.update_count+1} = evt.data.intensities;
            if obj.plot_flag
                obj.updatePlot;
            end
        end
    end
end

