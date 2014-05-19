%test an app on predicted-vs-real data
% in this case, line-finding
clear all; clc;
addpath ~/courses/mrpl/code/lab8/
load('full_predictor_mar27_2','dp');
np = load('full_predictor_mar27_2','predParamArray');
baseline = load('full_predictor_mar27_baseline','predParamArray');
load map
localizer = lineMapLocalizer(lines_p1,lines_p2);

%%

xl = [-0.4 4]; yl = [-0.53 2.4];
numLines = 5;
[baselineScore,realScore,simScore] = deal(0);
for i = 1:length(dp.testPoseIds)
    poseId = dp.testPoseIds(i);
    p2d = pose2D(dp.poses(:,poseId));
    xRob = dp.poses(1,poseId); yRob = dp.poses(2,poseId); thRob = dp.poses(3,poseId);

    % real data
    rangesReal = rangesFromObsArray(dp.obsArray,poseId,1);
    xReal = xRob+ rangesReal.*cos(dp.bearings+thRob);
    yReal = yRob+ rangesReal.*sin(dp.bearings+thRob);
    figure; hold on;
    plot(xReal,yReal,'go','MarkerSize',2);
    riReal = rangeImage(rangesReal); riReal.cleanup();
    linesReal = findLinesHT(riReal,numLines); 
    [linesReal_p1, linesReal_p2] = deal([]);
    for j = 1:length(linesReal)
        start = p2d.transformPoints(linesReal(j).point1);
        if size(start,2) > 1
            start = start(:,1);
        end
        last = p2d.transformPoints(linesReal(j).point2);
        plot([start(1) last(1)],[start(2) last(2)],'-k','LineWidth',2);
        linesReal_p1 = [linesReal_p1 start];
        linesReal_p2 = [linesReal_p2 last];
    end
    title('real ranges'); xlim(xl); ylim(yl);
   
    % np sim
    rangesSim = sampleFromParamArray(squeeze(np.predParamArray(i,:,:)),'normWithDrops');
    xSim = xRob+rangesSim.*cos(dp.bearings+thRob);
    ySim = yRob+rangesSim.*sin(dp.bearings+thRob);
    figure; hold on;
    plot(xSim,ySim,'ro','MarkerSize',2);
    riSim = rangeImage(rangesSim); riSim.cleanup();
    linesSim = findLinesHT(riSim,numLines);
    [linesSim_p1, linesSim_p2] = deal([]);
    for j = 1:length(linesSim)
        start = p2d.transformPoints(linesSim(j).point1);
        last = p2d.transformPoints(linesSim(j).point2);
        plot([start(1) last(1)],[start(2) last(2)],'-k','LineWidth',2);
        linesSim_p1 = [linesSim_p1 start];
        linesSim_p2 = [linesSim_p2 last];
    end
    title('np sim'); xlim(xl); ylim(yl);

    % baseline sim
    %rangesBaseline = sampleFromParamArray(squeeze(baseline.predParamArray(i,:,:)),'normWithDrops');
    rangesBaseline = roomLineMap.raycast(p2d.getPose, 4.5, dp.bearings);
    xBaseline = xRob+rangesBaseline.*cos(dp.bearings+thRob);
    yBaseline = yRob+rangesBaseline.*sin(dp.bearings+thRob);
    figure; hold on;
    plot(xBaseline,yBaseline,'bo','MarkerSize',2);
    riBaseline = rangeImage(rangesBaseline); riBaseline.cleanup();
    linesBaseline = findLinesHT(riBaseline,numLines);
    [linesBaseline_p1, linesBaseline_p2] = deal([]);
    for j = 1:length(linesBaseline)
        start = p2d.transformPoints(linesBaseline(j).point1);
        last = p2d.transformPoints(linesBaseline(j).point2);
        plot([start(1) last(1)],[start(2) last(2)],'-k','LineWidth',2);
        linesBaseline_p1 = [linesBaseline_p1 start];
        linesBaseline_p2 = [linesBaseline_p2 last];
    end
    title('baseline sim'); xlim(xl); ylim(yl);
    
    baselineScore = baselineScore+scoreLineFinding(lines_p1,lines_p2,linesBaseline_p1,linesBaseline_p2);
    realScore = realScore+scoreLineFinding(lines_p1,lines_p2,linesReal_p1,linesReal_p2);
    simScore = simScore+scoreLineFinding(lines_p1,lines_p2,linesSim_p1,linesSim_p2);
  
    close all;
end
baselineScore = baselineScore/length(dp.testPoseIds);
realScore = realScore/length(dp.testPoseIds);
simScore = simScore/length(dp.testPoseIds);
