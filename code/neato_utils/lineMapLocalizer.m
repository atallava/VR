classdef lineMapLocalizer < handle
    %lineMapLocalizer localize by matching range points to line map
        
    properties(Constant)        
        maxErr = 0.5;
        minPts = 5;
        % step increment when computing jacobian
        eps = [0.001,0.001,deg2rad(0.5)];
        maxIters = 15;
        % step size in pose when optimizing
        eta = 0.05;
    end
    
    properties (SetAccess = private)
        lines_p1 = [];
        lines_p2 = [];
        errThresh = 0.001;
        gradThresh = 0.0005;
    end
       
    methods
        function obj = lineMapLocalizer(lineObjArray,errThresh,gradThresh)
            % lineObjArray is an array of lineObject instances
            
            obj.lines_p1 = []; obj.lines_p2 = []; % 2 x n
            for i = 1:length(lineObjArray)
                if size(lineObjArray(i).lines,1) == 1
                    error('LINE SPECIFIED WITH SINGLE POINT.');
                end
                p1 = lineObjArray(i).lines(1:end-1,:);
                p2 = lineObjArray(i).lines(2:end,:);
                obj.lines_p1 = [obj.lines_p1 p1'];
                obj.lines_p2 = [obj.lines_p2 p2'];   
            end
                        
            if nargin > 2
                obj.errThresh = errThresh;
                obj.gradThresh = gradThresh;
            end
        end

        function ro2 = closestSquaredDistanceToLines(obj,p)
            %CLOSESTSQUAREDDISTANCETOLINES
            % Find the squared shortest distance from p to any line
            % segment in the supplied list of line segments. p1 is the
            % array of start point and p2 is the array of end points.            
            %
            % ro2 = CLOSESTSQUAREDDISTANCETOLINES(obj,p)
            %
            % p   - Array of 2D points of size 2 x n.
            %
            % ro2 - Array of closest distances of size 1 x n.
            
            r2Array = zeros(size(obj.lines_p1,2),size(p,2));
            for i = 1:size(obj.lines_p1,2)
                [r2Array(i,:) , ~] = closestPointOnLineSegment(p,...
                    obj.lines_p1(:,i),obj.lines_p2(:,i));                
            end
            ro2 = min(r2Array,[],1);
        end
        
        function ids = throwOutliers(obj,varargin)
            %THROWOUTLIERS Idenitfy outliers in scan.
            %
            % ids = THROWOUTLIERS(obj,ptsWorld)
            %
            % ptsWorld - Range readings expressed in the world frame,
            %            2 x n or 3 x n (homogeneous 2D coordinates)
            % 
            % ids = THROWOUTLIERS(obj,ptsLocal,pose)
            % ptsLocal - Range readings expressed in the local frame,
            %            2 x n or 3 x n (homogeneous 2D coordinates)
            % pose     - Array of length 3 or pose2D object.
            %
            % ids      - Logical array indicating outliers.
            
            if length(varargin) == 1
                pts = varargin{1};
            elseif length(varargin) == 2
                ptsLocal = varargin{1};
                pose = varargin{2};
                if size(ptsLocal,1) == 2
                    ptsLocal = [ptsLocal; ones(1,size(ptsLocal,2))];
                end
                if ~isa(pose,'pose2D')
                    pose = pose2D(pose);
                end
                pts = pose2D.transformPoints(ptsLocal,pose.getPose);
            end
                     
            r2 = obj.closestSquaredDistanceToLines(pts);
            ids = r2 > lineMapLocalizer.maxErr;
        end
        
        function avgErr = fitError(obj,pose,ptsInModelFrame)
            % Find the standard deviation of perpendicular distances of
            % all points to all lines
            
            % transform the points
            worldPts = pose.Tb2w()*ptsInModelFrame;
            err = 0.0;
            num = 0;
            for i = 1:size(worldPts,2)
                r2 = obj.closestSquaredDistanceToLines(worldPts(:,i));
                if r2 == Inf
                    continue;
                end
                err = err + r2;
                num = num + 1;
            end
            if(num > lineMapLocalizer.minPts)
                avgErr = sqrt(err)/num;
            else
                % not enough points to make a guess
                avgErr = inf;
            end
        end
        
        function [errPlus0,J] = getJacobian(obj,poseIn,modelPts)
            % Computes the  numerical gradient of the error function
            errPlus0 = obj.fitError(poseIn,modelPts);
                        
            poseDx = pose2D(poseIn.getPose() + [obj.eps(1);0;0]);
            errPlusDx = obj.fitError(poseDx, modelPts);
            poseDy = pose2D(poseIn.getPose() + [0;obj.eps(2);0]);
            errPlusDy = obj.fitError(poseDy, modelPts);
            poseDth = pose2D(poseIn.getPose() + [0;0;obj.eps(3)]);
            errPlusDth = obj.fitError(poseDth, modelPts);
            
            J = [errPlusDx, errPlusDy, errPlusDth]-errPlus0*ones(1,3);
            J = J./obj.eps;
        end
        
        function [successStory, outPose] = refinePose(obj, inPose, ptsInModelFrame, maxIters)
            if isempty(ptsInModelFrame)
                warning('NO POINTS INPUT.');
                successStory = struct('success',{},'err',{});
                outPose = inPose;
                return;
            end
            successStory.success = 0;
            outPose = pose2D(inPose.getPose());
            if nargin < 4
                maxIters = obj.maxIters;
            end
            for i = 1:maxIters
                [err, J] = obj.getJacobian(outPose, ptsInModelFrame);
                %fprintf('iter %d, error %f\n', i, err);
                if err == inf
                    break;
                end
                if norm(J) < obj.gradThresh
                    break;
                end
                dPose = -obj.eta*J';
                outPose.updatePose(outPose.getPose+dPose);
                if err < obj.errThresh
                    successStory.success = 1;
                    break;
                end
            end
            successStory.err = err;
        end

        function hf = drawLines(obj)
            hf = figure;
            hold on;
            for i = 1:size(obj.lines_p1,2)
               plot([obj.lines_p1(1,i) obj.lines_p2(1,i)],[obj.lines_p1(2,i) obj.lines_p2(2,i)],'LineWidth',2); 
            end
            axis equal;
            hold off;
        end
    end
        
end

























