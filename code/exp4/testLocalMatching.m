load roomLineMap
load test_local_matching_data

localizer = lineMapLocalizer(map.objects);
defaultLaser = laserClass(struct());
ri = rangeImage(struct('ranges',ranges));
outFlag = ri.rArray < ri.minUsefulRange | ri.rArray > ri.maxUsefulRange;
ptsInLaserFrame = ri.getPtsHomogeneous();
outFlag = outFlag | localizer.throwOutliers(ptsInLaserFrame,pose);
outIds = find(outFlag);
inIds = find(~outFlag);
numNbrs = 10;
minNbrs = floor(0.6*numNbrs);
p2d = pose2D(pose);
plot_option = 0;
pxId = inIds(1);
for pxId = inIds
    [left,right] = defaultLaser.getNbrIds(pxId,numNbrs);
    nbrs = [left right];
    nbrs = setdiff(nbrs,outIds);
    if length(nbrs) < minNbrs
        % accept current phi?
        continue;
    end
    ptsLocal = ptsInLaserFrame(:,nbrs);
    [success,poseLocal] = localizer.refinePose(p2d,ptsLocal,10);
    if plot_option
        hf = localizer.drawLines; hold on;
        ptsBefore = pose2D.transformPoints(ptsLocal,pose);
        ptsAfter = pose2D.transformPoints(ptsLocal,poseLocal.getPose());
        plot(ptsBefore(1,:),ptsBefore(2,:),'ro');
        plot(ptsAfter(1,:),ptsAfter(2,:),'go');
        hold off;
        waitforbuttonpress;
        close(hf);
    end
end
