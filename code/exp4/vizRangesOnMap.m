classdef vizRangesOnMap < handle
    %vizRangesOnMap visualize ranges overlaid on map

    properties (SetAccess = private)
        localizer
        laser
    end

    methods
        function obj = vizRangesOnMap(inputData)
            % inputData fields ('localizer','laser')
            % default (,laserClass(struct()))
            if isfield(inputData,'localizer')
                obj.localizer = inputData.localizer;
            else
                error('LOCALIZER NOT INPUT.');
            end
            if isfield(inputData,'laser')
                obj.laser = inputData.laser;
            else
                obj.laser = laserClass(struct());
            end
        end
        
        function hf = viz(obj,ranges,pose)
            % input (ranges,pose)
            hf = obj.localizer.drawLines();
            xl0 = xlim;
            yl0 = ylim;
            xlabel('x'); ylabel('y');
            hold on;
            quiver(pose(1),pose(2),0.2*cos(pose(3)),0.2*sin(pose(3)),'k','LineWidth',2);
            
            x = pose(1)+ranges.*cos(pose(3)+obj.laser.bearings);
            y = pose(2)+ranges.*sin(pose(3)+obj.laser.bearings);
            plot(x,y,'go');
            title(sprintf('pose: (%f,%f,%f)',pose(1),pose(2),pose(3)));
            xl0 = xl0+[-1 1];
            yl0 = yl0+[-1 1];
            xlim(xl0);
            ylim(yl0);
        end
    end

    methods (Static = true)
        
    end

end
