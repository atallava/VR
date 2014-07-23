classdef vizRangesOnMap < handle
    %VIZRANGESONMAP Visualize ranges overlaid on a map.
    %
    % Class properties.
    %  localizer - lineMapLocalizer object.
    %  laser     - Caution: in robot mode use appropriate laser.
    %  rob       - Neato object.
    %  rstate    - robState object, attached to rob. 
    %  mode      - 0: manual, 1: robot. 
    %
    % Class methods.
    %  vizRangesOnMap - Constructor.
    %  viz            - Does the visualization work.
    
    properties (SetAccess = private)
        localizer
        laser
        rob
        rstate
        mode
        listenerHandle
        hfig; hquiver; hranges;
    end

    methods
        function obj = vizRangesOnMap(inputStruct)
            % inputStruct fields ('localizer','laser','rob','rstate')
            % default (,laserClass(struct()))
            if isfield(inputStruct,'localizer')
                obj.localizer = inputStruct.localizer;
            else
                error('LOCALIZER NOT INPUT.');
            end
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
                obj.laser = laserClass(struct());
            end
            if ~isfield(inputStruct,'rob') && ~isfield(inputStruct,'rstate')
                obj.mode = 0;
            elseif isfield(inputStruct,'rob') && isfield(inputStruct,'rstate')
                obj.rob = inputStruct.rob;
                obj.rstate = inputStruct.rstate;
                obj.mode = 1;
            else
                error('IN ROBOT MODE BOTH ROB AND RSTATE MUST BE PASSED AS INPUTS.');
            end
            if obj.mode == 1
                obj.listenerHandle = addlistener(obj.rob.laser,'OnMessageReceived',@(src,evt) vizRangesOnMap.eventResponse(src,evt,obj));
            end
        end
        
        function viz(obj,ranges,refPose)
            %VIZ Visualize ranges transformed by pose.
            %
            % ranges    - Array of ranges.
            % refPose   - Length 3 array, reference pose. Will be
            %             transformed to pose in laser frame.
            
            if iscolumn(ranges)
                ranges = ranges';
            end
            lPose = obj.laser.refPoseToLaserPose(refPose);
            if  isempty(obj.hfig) || ~ishandle(obj.hfig)
                obj.hfig = obj.localizer.drawLines();
            end
            xl0 = xlim;
            yl0 = ylim;
            xlabel('x'); ylabel('y');
            hold on;
            if isempty(obj.hquiver) || ~ishandle(obj.hquiver)
                obj.hquiver = quiver(lPose(1),lPose(2),0.2*cos(lPose(3)),0.2*sin(lPose(3)),'k','LineWidth',2);
            else
                set(obj.hquiver,'XData',lPose(1),'YData',lPose(2),'UData',0.2*cos(lPose(3)),'VData',0.2*sin(lPose(3)));
            end
            
            x = lPose(1)+ranges.*cos(lPose(3)+obj.laser.bearings);
            y = lPose(2)+ranges.*sin(lPose(3)+obj.laser.bearings);
            if isempty(obj.hranges) || ~ishandle(obj.hranges)
                obj.hranges = plot(x,y,'go');
                xl0 = xl0+[-1 1];
                yl0 = yl0+[-1 1];
            else
                set(obj.hranges,'XData',x,'YData',y);
                xlim(xl0);
                ylim(yl0);
            end
            title(sprintf('laser pose: (%f,%f,%f)',lPose(1),lPose(2),lPose(3)));
        end
        
        function togglePlot(obj)
           if ishandle(obj.hfig)
               state = get(obj.hfig,'visible');
               switch state
                   case 'on'
                       set(obj.hfig,'visible','off');
                   case 'off'
                       set(obj.hfig,'visible','on');
               end
           end
        end
        
        function delete(obj)
            if obj.mode == 1 && obj.listenerHandle.isvalid
                obj.listenerHandle.delete;
            end
        end
    end

    methods (Static = true)
        function eventResponse(src,evt,obj)
            obj.viz(evt.data.ranges,obj.rstate.pose);
        end
    end
end