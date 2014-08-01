classdef localMatch < handle
    %localMatch

    properties (SetAccess = private)
        localizer
        laser
        map
        clusterer
        refineIterations = 20;
    end

    methods
        function obj = localMatch(inputStruct)
            % inputStruct fields ('localizer','laser','map',<clusterer specific fields>)
            % default (,,)
            if isfield(inputStruct,'localizer')
                obj.localizer = inputStruct.localizer;
            else
                error('LOCALIZER NOT INPUT.');
            end
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
                obj.laser = laserClass(struct());
                inputStruct.laser = obj.laser;
            end
            if isfield(inputStruct,'map')
                obj.map = inputStruct.map;
            else
                error('MAP NOT INPUT.');
            end
            obj.clusterer = clusterPixels(inputStruct);
        end
        
        function outIds = getOutIds(obj,ranges,pose)
            % note this implies that the outliers will not be replicated
            % in the simulator
            ri = rangeImage(struct('ranges',ranges));
            outFlag = ~(ri.rArray >= ri.minUsefulRange & ri.rArray <= ri.maxUsefulRange);
            ptsInLaserFrame = ri.getPtsHomogeneous();
            outFlag = outFlag | obj.localizer.throwOutliers(ptsInLaserFrame,pose);
            outIds = find(outFlag);
        end
        
        function inClusters = getInClusters(obj,outIds)
            inIds = setdiff(1:obj.laser.nPixels,outIds);
            outClusters = obj.clusterer.getOutClusters(outIds);
            inClusters = obj.clusterer.getInClusters(outClusters,inIds);
        end
        
        function localPoses = getLocalPoses(obj,ranges,clusters,pose)
            % pose is a length 3 array
            % localPoses is 3 x length(inClusters)
            
            ri = rangeImage(struct('ranges',ranges));
            ptsInLaserFrame = ri.getPtsHomogeneous();
            p2d = pose2D(pose);
            localPoses = zeros(3,length(clusters));
            for i = 1:length(clusters)
                section = clusters(i).members;
                ptsLocal = ptsInLaserFrame(:,section);
                [~,localPose] = obj.localizer.refinePose(p2d,ptsLocal,obj.refineIterations);
                localPoses(:,i) = localPose.getPose();
            end
        end
        
        function phiArray = getLocalPhi(obj,clusters,localPoses)
            % right now phi is r,alpha. could extend this to local geometry
            phiArray = nan(obj.laser.nPixels,2);
            for i = 1:length(clusters)
                section = clusters(i).members;
                [r,alpha] = obj.map.raycast(localPoses(:,i),obj.laser.maxRange,obj.laser.bearings(section));
                phiArray(section,1) = r; phiArray(section,2) = alpha;
            end
        end
    end

    methods (Static = true)
    end

end
