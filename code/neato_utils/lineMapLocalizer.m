classdef lineMapLocalizer < handle
    %lineMapLocalizer localize by matching range points to line map
        
    properties(Constant)        
        minPts = 5;
        % step increment when computing jacobian
        eps = [0.001,0.001,deg2rad(0.5)];
        maxIters = 15;
        % step size in pose when optimizing
    
    end
    
    properties (SetAccess = private)
        maxErr = 0.05;
        lines_p1 = [];
        lines_p2 = [];
        errThresh = 0.001;
        gradThresh = 0.0005;
        dPoseThresh = 1e-6;
        eta = 0.1;        
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
            
            p = p(1:2,:);
            r2Array = zeros(size(obj.lines_p1,2),size(p,2));
            for i = 1:size(obj.lines_p1,2)
                %[r2Array(i,:) , ~] = closestPointOnLineSegment(p,...
                    %obj.lines_p1(:,i),obj.lines_p2(:,i));
                r2Array(i,:) = myDist(p,obj.lines_p1(:,i),obj.lines_p2(:,i));
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
            ids = sqrt(r2) > obj.maxErr;
		end
        
        function avgErr = fitError(obj,pose,ptsInModelFrame)
            % Find the standard deviation of perpendicular distances of
            % all points to all lines
            
            % transform the points
            worldPts = pose.Tb2w()*ptsInModelFrame;
            
            r2 = obj.closestSquaredDistanceToLines(worldPts);
            r2(r2 == Inf) = [];
            err = sum(r2);
            num = length(r2);
            if(num >= lineMapLocalizer.minPts)
                avgErr = sqrt(err)/num;
            else
                % not enough points to make a guess
                avgErr = inf;
            end
        end
        
        function [errPlus0,J] = getJacobian(obj,poseIn,modelPts)
            % Computes the  numerical gradient of the error function
            errPlus0 = obj.fitError(poseIn,modelPts);
            
            J = zeros(1,3);
            for i = 1:3
                dP = zeros(3,1); dP(i) = obj.eps(i);
                posePlus = pose2D(poseIn.getPose()+dP);
                poseMinus = pose2D(poseIn.getPose()-dP);
                errPlus = obj.fitError(posePlus,modelPts);
                errMinus = obj.fitError(poseMinus,modelPts);
                J(i) = (errPlus-errMinus);
            end
            J = J./(2*obj.eps);
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
            [err,~] = obj.getJacobian(inPose,ptsInModelFrame); % For the case of 0 iterations.
            for i = 1:maxIters
                [err, J] = obj.getJacobian(outPose, ptsInModelFrame);
                if (err == inf) || any(J == inf)
                    break;
                end
                if norm(J) < obj.gradThresh
                    break;
                end
                dPose = -obj.eta*J';
                newErr = Inf;
                % Reduce step size till error reduces or dPose is too
                % small.
                while norm(dPose) > obj.dPoseThresh
                    newPose = pose2D(outPose.getPose+dPose);
                    newErr = obj.fitError(newPose,ptsInModelFrame);
                    if newErr < err
                        break;
                    else
                        dPose = 0.5*dPose;
                    end
                end
                % If error could not be reduced even after decreasing step
                % size, break.
                if newErr > err
                    break;
                end
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
               plot([obj.lines_p1(1,i) obj.lines_p2(1,i)],[obj.lines_p1(2,i) obj.lines_p2(2,i)],'LineWidth',1); 
            end
            axis equal;
            hold off;
        end
    end
        
end
