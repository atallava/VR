%process march 27 collected data
clear all; clc;
load data_mar27
addpath ~/Documents/MATLAB/neato_utils/

nPoses = length(t_range_collection);
tStart = [t_range_collection.('start')]-lzr.tArray(1);
tEnd = [t_range_collection.('end')]-lzr.tArray(1);
tCommonEnc = enc.tArray;
tCommonEnc = tCommonEnc-tCommonEnc(1);
tCommonLzr = lzr.tArray;
tCommonLzr = tCommonLzr-tCommonLzr(1);

%% fill observation array
obsArray = cell(nPoses,360);

for i = 1:nPoses
    ids = find(lzr.tArray >= t_range_collection(i).start & lzr.tArray <= t_range_collection(i).end);
    temp = lzr.rangeArray(ids);
    temp = cell2mat(temp');
    for j = 1:360
        obsArray{i,j} = temp(:,j);
    end    
end

%% pose from encoders + laser
clc;
load map;
poses = zeros(3,nPoses);
rState = robState([],'manual',[0.103;0.166;0]);
poseCount = 1;
lzrCount = 1;
localizer = lineMapLocalizer(roomLineMap.objects);

for i = 1:enc.update_count
    if enc.encArray(i+1).left == 0 && enc.encArray(i+1).right == 0
        % hack, since zero encoder readings screw up things since no
        % filtering
        continue;
    end
    
    if tCommonEnc(i) > tStart(poseCount) && tCommonEnc(i) < tEnd(poseCount)
        continue;
    end
    
    if i > 1
        if tCommonEnc(i) >= tEnd(poseCount) && tCommonEnc(i-1) < tEnc(poseCount)
            temp = find(tCommonLzr > tEnc(poseCount));
            lzrCount = temp(1);
        end
    end
    
        if tCommonEnc(i) > tCommonLzr(lzrCount)
        t1 = tic;
        % update using laser
        ranges = lzr.rangeArray{lzrCount+1};
        ri = rangeImage(struct('ranges',ranges,'cleanup',1));
        ptsLocal = [ri.xArray; ri.yArray];
        ptsLocal = [ptsLocal; ones(1,size(ptsLocal,2))];
        ptsLocal = ptsLocal(:,1:4:end);
        poseEst = pose2D(rState.pose);
        outIds = localizer.throwOutliers(poseEst,ptsLocal);
        ptsLocal(:,outIds) = [];
        [success, poseOut] = localizer.refinePose(poseEst,ptsLocal,20);
        lzrCount = lzrCount+4;
        %fprintf('scan match took %f seconds\n',toc(t1));
        
        rState.reset(poseOut.getPose());
        rState.setEncoders(rState.encoders.data,tCommonEnc(i-1));
        
        hf = localizer.drawLines();
        hf = plotScan(poseOut,ptsLocal,hf);
        set(hf,'visible','off');
        title(sprintf('laser count %d',lzrCount));
        print('-dpng','-r72',sprintf('images/pose_est/enc%d_lzr%d.png',i,lzrCount));
        close(hf);
    end
    rState.setEncoders(enc.encArray(i+1),tCommonEnc(i));
    
    if tCommonEnc(i) <= tStart(poseCount) && tCommonEnc(i+1) > tStart(poseCount)
        fprintf('encCount: %d, lzrCount: %d, poseCount: %d\n',i,lzrCount,poseCount);
        poses(:,poseCount) = rState.pose;
        poseCount = poseCount+1;
        if poseCount > nPoses
            break;
        end
    end
end

%% plot poses

figure;
axis equal; hold on;
xlim([min(poses(1,:)) max(poses(1,:))]);
ylim([min(poses(2,:)) max(poses(2,:))]);
for i = 1:nPoses
    text(poses(1,i),poses(2,i),sprintf('%d',i));
    %plot(poses(1,i),poses(2,i),'+');
end



