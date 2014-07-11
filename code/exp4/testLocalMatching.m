load roomLineMap
load test_local_matching_data

localizer = lineMapLocalizer(map.objects);
laser = laserClass(struct());
ri = rangeImage(struct('ranges',muRanges));
outFlag = ri.rArray < ri.minUsefulRange | ri.rArray > ri.maxUsefulRange;
ptsInLaserFrame = ri.getPtsHomogeneous();
outFlag = outFlag | localizer.throwOutliers(ptsInLaserFrame,pose);
outIds = find(outFlag);
inIds = find(~outFlag);
clusterer = clusterPixels(struct('laser',laser));
outClusters = clusterer.getOutClusters(outIds);
inClusters = clusterer.getInClusters(outClusters,inIds);

%%
p2d = pose2D(pose);
plot_option = 1;
for i = 1:length(inClusters)
    section = inClusters(i).members;
    ptsLocal = ptsInLaserFrame(:,section);
    [success,poseLocal] = localizer.refinePose(p2d,ptsLocal,10);
    if plot_option
        hf = localizer.drawLines; hold on;
        ptsBefore = pose2D.transformPoints(ptsLocal,pose);
        ptsAfter = pose2D.transformPoints(ptsLocal,poseLocal.getPose());
        plot(ptsBefore(1,:),ptsBefore(2,:),'ro');
        plot(ptsAfter(1,:),ptsAfter(2,:),'go');
        hold off;
        title(sprintf('%s',mat2str(section)));
        waitforbuttonpress;
        close(hf);
    end
end
