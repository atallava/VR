classdef laserHistory < handle
    %laserHistory store laser values in an array
        
    properties
        log
        tArray
        update_count
        listenerHandle
        rob
        bearings
        hfig; hplot
        plot_flag
    end
    
    methods
        function obj = laserHistory(rob)
            %LASERHISTORY Constructor.
            %
            % obj = LASERHISTORY(rob)
            %
            % rob - An object that broadcasts range data, e.g. real,
            %       neato or playbackTool object.
            %
            % obj - Instance.

            obj.rob = rob;
            obj.log = struct('ranges',{},'intensities',{});
            obj.tArray = [];
            obj.update_count = 0;
            obj.bearings = deg2rad(0:359);
            obj.hfig = figure; obj.hplot = plot(0,0,'.'); 
            axis equal; xlabel('x'); ylabel('y'); set(obj.hfig,'visible','off'); 
            obj.plot_flag = 0;
            obj.listenerHandle = addlistener(rob.laser,'OnMessageReceived',@(src,evt) laserHistory.laserEventResponse(src,evt,obj));
        end
        
        function reset(obj)
            obj.listenerHandle.delete;
            pause(0.01);
            obj.log = struct('ranges',{},'intensities',{});
            obj.tArray = [];
            obj.update_count = 0;
            obj.listenerHandle = addlistener(obj.rob.laser,'OnMessageReceived',@(src,evt) encHistory.laserEventResponse(src,evt,obj));
        end
        
        function togglePlot(obj)
            if ~ishandle(obj.hfig)
                return;
            end
            if obj.plot_flag
                set(obj.hfig,'visible','off');
            else
                set(obj.hfig,'visible','on');
            end
            obj.plot_flag = ~obj.plot_flag;
        end
        
        function updatePlot(obj)
            ranges = obj.log(end).ranges;
            if isempty(ranges)
                return
            end
            x = obj.log(end).ranges.*cos(obj.bearings);
            y = obj.log(end).ranges.*sin(obj.bearings);
            if ishandle(obj.hfig)
                set(obj.hplot,'XData',x,'YData',y);
            else
                obj.hfig = hfig; obj.hplot = plot(x,y,'.');
            end
        end
        
        function stopListening(obj)
            obj.listenerHandle.delete;
        end
    end
            
    methods (Static)
        function laserEventResponse(src,evt,obj)
            obj.update_count = obj.update_count+1;
            obj.tArray(obj.update_count) = evt.data.header.stamp.secs + (evt.data.header.stamp.nsecs*1e-9);
            obj.log(obj.update_count).ranges = evt.data.ranges;
            if isfield(evt.data,'intensities')
                % Currently not all laser interfaces broadcast intensities.
                obj.log(obj.update_count).intensities = evt.data.ranges;
            end
            if obj.plot_flag
                obj.updatePlot;
            end
        end
    end
end

