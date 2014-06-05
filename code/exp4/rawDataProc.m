classdef rawDataProc < handle
    %rawDataProc 

    properties (SetAccess = private)
        % lzrHist is a laserHistory object
        % encHist is a encHistory object
        % poses is 3 x n
        % obsArray is a cell array nPoses x nBearings
        % obsArrayByPose is a cell array 1 x nPoses
        lzrHist; encHist
        t_range_collection
        nPoses
        poses; obsArray; obsArrayByPose
    end
    
    methods
        function obj = rawDataProc(inputData)
            % inputData fields ('lzrHist','encHist','t_range_collection')
            % default (,,)
            if isfield(inputData,'lzrHist')
                obj.lzrHist = inputData.lzrHist;
            else
            end
            if isfield(inputData,'encHist')
                obj.encHist = inputData.encHist;
            else
            end
            if isfield(inputData,'t_range_collection')
                obj.t_range_collection = inputData.t_range_collection;
            else
            end
            obj.nPoses = length(obj.t_range_collection);
        end
        
        function fillObsArray(obj)
            obj.obsArray = cell(obj.nPoses,360);
            obj.obsArrayByPose = cell(1,obj.nPoses);
            for i = 1:obj.nPoses
                ids = obj.lzrHist.tArray >= obj.t_range_collection(i).start & obj.lzrHist.tArray <= obj.t_range_collection(i).end;
                temp = obj.lzrHist.rangeArray(ids);
                temp = cell2mat(temp');
                obj.obsArrayByPose{i} = temp;
                for j = 1:360
                    obj.obsArray{i,j} = temp(:,j);
                end
            end
        end
        
        function fillPoses(obj,poses)
           obj.poses = poses; 
        end
    end

    methods (Static = true)
    end

end
