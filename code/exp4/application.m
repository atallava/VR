%test an app on predicted-vs-real data
% in this case, line-finding
clear all; clc;
addpath ~/courses/mrpl/code/lab8/
load full_predictor_mar27
load map
localizer = lineMapLocalizer(lines_p1,lines_p2);


while true
for i = randperm(length(dp.testPoseIds),1)
    poseId = dp.testPoseIds(i);
    p2d = pose2D(dp.poses(:,poseId));
    hf1 = localizer.drawLines();
    xl0 = xlim;
    yl0 = ylim;
    xlabel('x'); ylabel('y');
    hold on;
    poseId = dp.testPoseIds(i);
    xRob = dp.poses(1,poseId); yRob = dp.poses(2,poseId); thRob = dp.poses(3,poseId);
    plot(xRob,yRob,'g+');
    
    rangesReal = rangesFromObsArray(dp.obsArray,poseId,1);
    xReal = xRob+ rangesReal.*cos(dp.rHist.bearings+thRob);
    yReal = yRob+ rangesReal.*sin(dp.rHist.bearings+thRob);
    plot(xReal,yReal,'go','MarkerSize',2);
    riReal = rangeImage(rangesReal,1,1);
    lines = findLinesHT(riReal,4);
    for j = 1:length(lines)
        start = p2d.transformPoints(lines(j).point1);
        last = p2d.transformPoints(lines(j).point2);
        plot([start(1) last(1)],[start(2) last(2)],'-g','LineWidth',2);
    end
    title(sprintf('pose %d: (%f,%f,%f)',poseId,xRob,yRob,thRob));
   
    % use class method to sample from pdf
    rangesSim = sampleFromParamArray(squeeze(predParamArray(i,:,:)),'normWithDrops');
        
    xSim = xRob+rangesSim.*cos(dp.rHist.bearings+thRob);
    ySim = yRob+rangesSim.*sin(dp.rHist.bearings+thRob);
    plot(xSim,ySim,'ro','MarkerSize',2);
    riSim = rangeImage(rangesSim,1,1);
    lines = findLinesHT(riSim,4);
    for j = 1:length(lines)
        start = p2d.transformPoints(lines(j).point1);
        last = p2d.transformPoints(lines(j).point2);
        plot([start(1) last(1)],[start(2) last(2)],'-r','LineWidth',2);
    end
    annotation('textbox',[.6,0.8,.1,.1], ...
    'String', {'green: real ranges','red: simulated ranges'});
    %legend('robot','real data','predicted data');
    xlim(xl0); ylim(yl0);
    hold off;
  
end
waitforbuttonpress;
close(hf1);
end