classdef laserClass < handle
    %laserClass sensor information
    
    properties (SetAccess = private)
        % distance unit: m
        % angle unit: rad
        minRange
        maxRange
        rangeRes
        bearings
        nBearings
        nullReading
        Tsensor % describes sensor frame wrt some other frame, typically robot origin
    end
    
    methods
        function obj = laserClass(inputStruct)
            % inputStruct fields ('maxRange','rangeRes','bearings','nullReading','Tsensor')
            % default (4.5, 0.001, deg2rad(0:359), 0, eye(3))
            if isfield(inputStruct,'minRange')
                obj.minRange = inputStruct.minRange;
            else
                obj.minRange = 0;
            end
            if isfield(inputStruct,'maxRange')
                obj.maxRange = inputStruct.maxRange;
            else
                obj.maxRange = 4.5;
            end
            if isfield(inputStruct,'rangeRes')
                obj.rangeRes = inputStruct.rangeRes;
            else
                obj.rangeRes = 0.001;
            end
            if isfield(inputStruct,'bearings')
                obj.bearings = inputStruct.bearings;
            else
                obj.bearings = deg2rad(0:359);
            end
            if isfield(inputStruct,'Tsensor')
                obj.Tsensor = inputStruct.Tsensor;
            else
                obj.Tsensor = eye(3);
            end
            obj.nBearings = length(obj.bearings);
            if isfield(inputStruct,'nullReading')
                obj.nullReading = inputStruct.nullReading;
            else
                obj.nullReading = 0;
            end
        end
        
        function laserPose = refPoseToLaserPose(obj,refPose)
           % given reference pose, return laser pose
           laserPose = pose2D.pose1ToPose2(refPose,obj.Tsensor);
        end
        
        function refPose = laserPoseToRefPose(obj,laserPose)
            % given laser pose, return reference pose
            refPose = pose2D.pose1ToPose2(laserPose,inv(obj.Tsensor));
        end
        
        function [l,r] = getNbrIds(obj,i,numNbrs,nPix)
            if nargin < 4
                nPix = obj.nBearings;
            end
            l = i-numNbrs/2:i-1;
            l(l<1) = l(l<1)+nPix;
            r = i+1:i+numNbrs/2;
            r(r>nPix) = r(r>nPix)-nPix+1;
        end
        
        function ySet = readingsSet(obj)
            %READINGSSET Discrete set of possible laser readings.
            %
            % ySet = READINGSSET(obj)
            %
            %
            % ySet - Vector with sorted values.
            
            nY = round(obj.maxRange/obj.rangeRes)+1;
            ySet = linspace(0,obj.maxRange,nY);
        end
        
        function projectedData = projectDataToReadingsSet(obj,data)
            data(data < 0) = 0;
            data(data > obj.maxRange) = obj.maxRange;
            
            dataIsVec = true;
            if ~isVec(data)
                dataIsVec = false;
                originalSize = size(data);
                data = data(:);
            end
            
            [data,dataIsColumn] = flipVecToColumn(data);
            nData = length(data);
            ySet = obj.readingsSet();
            yResn = ySet(2)-ySet(1);
            ySet = flipVecToRow(ySet);
            yMat = repmat(ySet,nData,1);
            yDiff = bsxfun(@minus,yMat,data);
            yDiff = abs(yDiff);
            [~,minIds] = min(yDiff,[],2);
            projectedData = ySet(minIds);
            
            % formatting
            if dataIsColumn
                projectedData = flipVecToColumn(projectedData);
            else
                projectedData = flipVecToRow(projectedData);
            end
            
            if ~dataIsVec
                projectedData = reshape(data,originalSize);
            end
        end
    end
end

