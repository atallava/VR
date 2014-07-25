% draw error fields
load application_test_data
load ../mats/roomLineMap.mat
localizer = lineMapLocalizer(map.objects);

nPatterns = size(patternSet,2);
for poseId = 1:length(data)
    pose = data(poseId).pose;
    mErr = zeros(5,nPatterns);
    cmap = colormap('jet'); close(gcf);
    for i = 1:size(mErr,1)
        mErr = getPoseErrorData(i);
        mErr(i,:) = mErr(poseId,:);
    end
    minErr = min(mErr(:)); maxErr = max(mErr(:));
    
    for i = 1:size(mErr,1)
        str = choiceString(i);
        hf = localizer.drawLines(); set(hf,'visible','off');
        hold on;
        for j = 1:nPatterns
            p = pose+patternSet(:,j);
            coords = getRotatedRect(p);
            index = 1+floor((mErr(i,j)-minErr)*(size(cmap,1)-1)/(maxErr-minErr));
            patch(coords(:,1),coords(:,2),'w','FaceColor',cmap(index,:));
        end
        hold off;
        colorbar;
        caxis([minErr maxErr]);
        print('-dpng','-r72',sprintf('images/error_field_by_pose/pose_%d_error_field_%s_data.png',poseId,str));
        close(hf);
    end
end

%% plot pose norms
load('application_test_data','patternSetPoseNorm');
for i = 1:5
    [m,s] = getPoseErrorData(i);
    str = choiceString(i);
    hf = figure; set(hf,'visible','off');
    plot(patternSetPoseNorm,m,'+');
    xlim([0 0.7]); ylim([0 0.7]); 
    hold on;
    plot([0 0.7],[0 0.7]);
    xlabel('pattern set pose norm'); ylabel('mean refined pose error norm');
    title(sprintf('Stats for %s data',strrep(str,'_','\_')));
    print('-dpng','-r72',sprintf('images/refined_error_vs_pattern_error_%s.png',str));
    close(hf);
end