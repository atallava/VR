% naively generate a room with lineObject obstacles

walls = lineObject;
shift = [-650 -395]*0.5*0.01;
walls.lines = [0 0; 650 0; 650 395; 0 395; 0 0]*0.01;
walls.lines = bsxfun(@plus,walls.lines,shift);
regions(1).xRange = [30 100]*0.01+shift(1); regions(1).yRange = [30 365]*0.01+shift(2);
regions(2).xRange = [30 620]*0.01+shift(1); regions(2).yRange = [30 50]*0.01+shift(2);
regions(3).xRange = [30 620]*0.01+shift(1); regions(3).yRange = [345 365]*0.01+shift(2);

numBodies = 10;
bodies = lineObject.empty(0,numBodies);
for i = 1:numBodies
    if rand > 0.2
        body = randomBody(0);
    else
        body = randomBody(1);
    end
    r = randperm(3,1);
    shift = [unifrnd(regions(r).xRange(1),regions(r).xRange(2)) unifrnd(regions(r).yRange(1),regions(r).yRange(2))];
    body.lines = bsxfun(@plus,body.lines,shift);
    bodies(i) = body;
end
room = lineMap([walls bodies]);