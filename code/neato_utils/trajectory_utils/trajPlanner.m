classdef trajPlanner < handle
        
    properties (SetAccess = private)
        tablesFname 
        tables
    end
    
    methods
        function obj = trajPlanner(inputData)
            if nargin < 1
                someUsefulPaths;
                obj.tablesFname = [pathToM '/neato_utils/trajectory_utils/trajectory_table.mat'];
            else
                if isfield(inputData,'tablesFname')
                    obj.tablesFname = inputData.tablesFname;
                else
                    error('tablesFname not input');
                end
            end
            load(obj.tablesFname);
            obj.tables = tt;
        end
        
        function res = planPath(obj,startPose,finalPose)
            relPose = obj.computeRelPose(startPose,finalPose);
            q = atan2(relPose(2),relPose(1));
            th = relPose(3);
            el = obj.tables.eLTable.get([q,th]);
            er = obj.tables.eRTable.get([q,th]);
            if el == Inf && er == Inf
                res = [];
                return;
            elseif el < er
                params = [obj.tables.aLTable.get([q,th]) obj.tables.bLTable.get([q,th]) 1];
            else
                params = [obj.tables.aRTable.get([q,th]) obj.tables.bRTable.get([q,th]) 1];
            end
            
            csp = cubicSpiral(struct('params',params));
            lambda = relPose(1)/csp.finalPose(1);
            params = [params(1)/lambda^3 params(2)/lambda^4 lambda*params(3)];
            res = cubicSpiral(struct('params',params,'startPose',startPose));
        end
        
        function res = planWithWaypoints(obj,waypoints)
            % waypoints is a 3 x n array
            nWaypoints = size(waypoints,2);
            for i = 1:(nWaypoints-1)
                if i == 1
                    cspArray(i) = obj.planPath(waypoints(:,i),waypoints(:,i+1));
                else
                    cspArray(i) = obj.planPath(cspArray(i-1).finalPose,waypoints(:,i+1));
                end
            end
            res = stitchedSpirals(cspArray);
        end
        
        function relPose = computeRelPose(obj,pose1,pose2)
            poseObj = pose2D(pose1);
            relPose = poseObj.Tb2w\[pose2(1); pose2(2); 1];
            relPose(3) = thDiff(pose1(3),pose2(3));
        end
    end
    
end

