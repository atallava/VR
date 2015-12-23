classdef vizRangesOnMap < handle
    %VIZRANGESONMAP Visualize ranges overlaid on a map.
    %
    % Class properties.
    %  map       - lineMap object.
    %  laser     - Caution: in robot mode use appropriate laser.
    %  rob       - Neato object.
    %  rstate    - robState object, attached to rob. 
    %  mode      - 0: manual, 1: robot. 
    %
    % Class methods.
    %  vizRangesOnMap - Constructor.
    %  viz            - Does the visualization work.
    
    properties (SetAccess = private)
        map; map_lines_p1; map_lines_p2;
        laser
        rob
        rstate
        mode
        listenerHandle
        hfig; hquiver; hranges;
    end

    methods
        function obj = vizRangesOnMap(inputStruct)
            % inputStruct fields ('map','laser','rob','rstate')
            % default (,laserClass(struct()))
            if isfield(inputStruct,'map')
                obj.map = inputStruct.map;
                obj.getLinesFromMap();
            else
                error('MAP NOT INPUT.');
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
        
        function getLinesFromMap(obj)
            lineObjArray = obj.map.objects;
            if isempty(obj.map)
                error('vizRangesFromMap:getLinesFromMap:emptyMap', ...
                    'Function called without specifying map');
            end
            obj.map_lines_p1 = []; obj.map_lines_p2 = []; % 2 x n
            for i = 1:length(lineObjArray)
                if size(lineObjArray(i).lines,1) == 1
                    error('LINE ON MAP SPECIFIED WITH SINGLE POINT.');
                end
                p1 = lineObjArray(i).lines(1:end-1,:);
                p2 = lineObjArray(i).lines(2:end,:);
                obj.map_lines_p1 = [obj.map_lines_p1 p1'];
                obj.map_lines_p2 = [obj.map_lines_p2 p2'];
            end
        end
        
        function hf = drawLines(obj)
            hf = figure;
            hold on;
            for i = 1:size(obj.map_lines_p1,2)
               plot([obj.map_lines_p1(1,i) obj.map_lines_p2(1,i)],...
                   [obj.map_lines_p1(2,i) obj.map_lines_p2(2,i)],'b','LineWidth',1); 
            end
            axis equal;
            hold off;
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
                obj.hfig = obj.drawLines();
			end
            hchildren = get(obj.hfig,'children');
			ha = hchildren(1); % assuming that first child is axes
            xl0 = xlim(ha);
            yl0 = ylim(ha);
            xlabel(ha,'x'); ylabel(ha,'y');
            hold(ha,'on');
            if isempty(obj.hquiver) || ~ishandle(obj.hquiver)
                obj.hquiver = quiver(lPose(1),lPose(2),0.2*cos(lPose(3)),0.2*sin(lPose(3)),'k','LineWidth',2);
                adjust_quiver_arrowhead_size(obj.hquiver,5);
            else
                set(obj.hquiver,'XData',lPose(1),'YData',lPose(2),'UData',0.2*cos(lPose(3)),'VData',0.2*sin(lPose(3)));
            end
            
            x = lPose(1)+ranges.*cos(lPose(3)+obj.laser.bearings);
            y = lPose(2)+ranges.*sin(lPose(3)+obj.laser.bearings);
            if isempty(obj.hranges) || ~ishandle(obj.hranges)
                obj.hranges = plot(x,y,'r.','MarkerSize',7);
                xl0 = xl0+[-0.5 0.5]; xlim(ha,xl0);
                yl0 = yl0+[-0.5 0.5]; ylim(ha,yl0);
			else
                set(obj.hranges,'XData',x,'YData',y);
                xlim(ha,xl0);
                ylim(ha,yl0);
            end
            title(ha,sprintf('laser pose: (%f,%f,%f)',lPose(1),lPose(2),lPose(3)));
            hold(ha,'off');
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
