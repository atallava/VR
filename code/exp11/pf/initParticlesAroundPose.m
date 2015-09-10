function particles = initParticlesAroundPose(map,support,xyScale,thScale,bBox,pose)
    
    xRange = 0.5;
    yRange = 0.5;
    thRange = deg2rad(10);
    xMax = pose(1)+xRange*0.5;
    xMin = pose(1)-xRange*0.5;
    yMax = pose(2)+yRange*0.5;
    yMin = pose(2)-yRange*0.5;
    thMax = pose(3)+thRange*0.5;
    thMin = pose(3)-thRange*0.5;
    
    xGrid = xMin:xyScale:xMax;
    yGrid = yMin:xyScale:yMax;
    thGrid = thMin:thScale:thMax;
    particles = struct('pose',{});
    
    
    count = 1;
    for i = 1:length(xGrid)
        for j = 1:length(yGrid)
            for k = 1:length(thGrid)
                x = xGrid(i); y = yGrid(j); th = thGrid(k);
                pose = [x; y; th];
                particles(count).pose = pose;
                count = count+1;
            end
        end
    end
end