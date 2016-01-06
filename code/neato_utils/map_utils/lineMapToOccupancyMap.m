function om = lineMapToOccupancyMap(lm,scale,xyLims)
%LINEMAPTOOCCUPANCYMAP 
% 
% om = LINEMAPTOOCCUPANCYMAP(lm,scale,xyLims)
% 
% lm     - lineMap object.
% scale  - Scalar.
% xyLims - [xMin xMax; yMin yMax].
% 
% om     - occupancyMap object.

om = occupancyMap(struct('scale',scale,'xyLims',xyLims,'pInit',0,'pOcc',1,'pFree',0));
for object = lm.objects
    lines = object.lines;
    nLines = size(lines,1)-1;
    for i = 1:nLines
        xyStart = lines(i,:);
        xyEnd = lines(i+1,:);
        [rcStart,rcEnd] = deal(zeros(1,2));
        [rcStart(1),rcStart(2)] = om.xy2rc(xyStart(1),xyStart(2));
        [rcEnd(1),rcEnd(2)] = om.xy2rc(xyEnd(1),xyEnd(2));
        ids = om.bresenhamWrapper(rcStart,rcEnd);
        om.logOddsGrid(ids) = om.prob2LogOdds(1);
    end
end
end