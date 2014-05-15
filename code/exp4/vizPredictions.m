function vizPredictions(dp,predParamArray,localizer)
%vizPredictions visualize real vs predicted data
% dp is an instance of dataProcessor

pmfPixel = randperm(dp.nPixels,1);
while true
for i = randperm(length(dp.testPoseIds),1)
    % visualize real vs simulated observations for some test pose
    hf1 = localizer.drawLines();
    xl0 = xlim+[-0.5 0.5];
    yl0 = ylim+[-0.5 0.5];
    xlabel('x'); ylabel('y');
    hold on;
    poseId = dp.testPoseIds(i);
    xRob = dp.poses(1,poseId); yRob = dp.poses(2,poseId); thRob = dp.poses(3,poseId);
    quiver(xRob,yRob,0.2*cos(thRob),0.2*sin(thRob),'k','LineWidth',2);
        
    rangesReal = rangesFromObsArray(dp.obsArray,poseId,1);
    xReal = xRob+ rangesReal.*cos(dp.bearings+thRob);
    yReal = yRob+ rangesReal.*sin(dp.bearings+thRob);
    plot(xReal,yReal,'go');
    title(sprintf('pose %d: (%f,%f,%f)',poseId,xRob,yRob,thRob));
   
    % use class method to sample from pdf
    rangesSim = sampleFromParamArray(squeeze(predParamArray(i,:,:)),'normWithDrops');
        
    xSim = xRob+rangesSim.*cos(dp.bearings+thRob);
    ySim = yRob+rangesSim.*sin(dp.bearings+thRob);
    plot(xSim,ySim,'ro');
    annotation('textbox',[.6,0.8,.1,.1], ...
    'String', {'green: real ranges','red: simulated ranges','black: robot'});
    %legend('robot','real data','predicted data');
    xlim(xl0); ylim(yl0);
    hold off;
    
    % visualize real and simulated pmfs for a particular pixel index
    params = predParamArray(i,:,pmfPixel);
    hf2 = vizPMFs(dp.obsArray{dp.testPoseIds(i),pmfPixel},params,@normWithDrops);
    suptitle(sprintf('pixel %d',dp.pixelIds(pmfPixel)));
      
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

