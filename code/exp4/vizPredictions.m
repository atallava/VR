function vizPredictions(dp,predParamArray,localizer.rsim)
%vizPredictions visualize real vs predicted data
% dp is a dataProcessor object

% pick some pixel for viewing histograms
pmfPixel = randperm(dp.laser.nPixels,1);
while true
% pick some test pose    
for i = randperm(length(dp.testPoseIds),1)
    hf1 = localizer.drawLines();
    xl0 = xlim+[-0.5 0.5];
    yl0 = ylim+[-0.5 0.5];
    xlabel('x'); ylabel('y');
    hold on;
    poseId = dp.testPoseIds(i);
    xRob = dp.poses(1,poseId); yRob = dp.poses(2,poseId); thRob = dp.poses(3,poseId);
    % draw robot
    quiver(xRob,yRob,0.2*cos(thRob),0.2*sin(thRob),'k','LineWidth',2);
        
    % plot real ranges
    rangesReal = rangesFromObsArray(dp.obsArray,poseId,1);
    xReal = xRob+rangesReal.*cos(dp.laser.bearings+thRob);
    yReal = yRob+rangesReal.*sin(dp.laser.bearings+thRob);
    plot(xReal,yReal,'go');
    title(sprintf('pose %d: (%f,%f,%f)',poseId,xRob,yRob,thRob));
   
    % plot sim ranges
    rangesSim = rangeSimulator.sampleFromParamArray(squeeze(predParamArray(i,:,:)),@normWithDrops);
    xSim = xRob+rangesSim.*cos(dp.laser.bearings+thRob);
    ySim = yRob+rangesSim.*sin(dp.laser.bearings+thRob);
    plot(xSim,ySim,'ro');
    annotation('textbox',[.6,0.8,.1,.1], ...
    'String', {'green: real ranges','red: simulated ranges','black: robot'});
    xlim(xl0); ylim(yl0);
    hold off;
    
    % plot histograms
    params = predParamArray(i,:,pmfPixel);
    hf2 = vizPMFs(dp.obsArray{dp.testPoseIds(i),pmfPixel},params,@normWithDrops,dp.laser);
    suptitle(sprintf('pixel %d',pmfPixel));
      
    % some fancy positioning for visibility
    figpos1 = get(hf1,'Position'); figpos2 = get(hf2,'Position');
    figwidth = figpos1(3); figshift = floor(figwidth*0.5+10);
    figpos1(1) = figpos1(1)-figshift; figpos2(1) = figpos2(1)+figshift;
    set(hf1,'Position',figpos1); set(hf2,'Position',figpos2);
end
waitforbuttonpress;
close(hf1,hf2);
end

end

