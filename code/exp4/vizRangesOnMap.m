classdef vizRangesOnMap < handle
    %vizRangesOnMap visualize ranges overlaid on map

    properties (SetAccess = private)
        localizer
        laser
    end

    methods
        function obj = vizRangesOnMap(inputStruct)
            % inputStruct fields ('localizer','laser')
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
        end
        
        function hf = viz(obj,ranges,refPose)
            %VIZ Visualize ranges transformed by pose.
            %
            % hf = VIZ(obj,ranges,refPose)
            %
            % ranges    - Array of ranges.
            % refPose   - Length 3 array, reference pose. Will be
            %             transformed to pose in laser frame.
            %
            % hf        - Plot handle.
            
            lPose = obj.laser.refPoseToLaserPose(refPose);
            
            hf = obj.localizer.drawLines();
            xl0 = xlim;
            yl0 = ylim;
            xlabel('x'); ylabel('y');
            hold on;
            quiver(lPose(1),lPose(2),0.2*cos(lPose(3)),0.2*sin(lPose(3)),'k','LineWidth',2);
            
            x = lPose(1)+ranges.*cos(lPose(3)+obj.laser.bearings);
            y = lPose(2)+ranges.*sin(lPose(3)+obj.laser.bearings);
            plot(x,y,'go');
            title(sprintf('laser pose: (%f,%f,%f)',lPose(1),lPose(2),lPose(3)));
            xl0 = xl0+[-1 1];
            yl0 = yl0+[-1 1];
            xlim(xl0);
            ylim(yl0);
        end
    end

    methods (Static = true)
        
    end

end
