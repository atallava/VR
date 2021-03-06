function particles = initParticlesUniform(map,support,bBox,xyScale,thScale)
    %INITPARTICLESUNIFORM 
    %
    % particles = INITPARTICLESUNIFORM(map,support,bBox,xyScale,thScale)
    %
    % map       - lineMap object.
    % support   - Struct with fields ('xv','yv').
    % bBox      - Struct with fields ('xv','yv').
    % xyScale   - Scalar.
    % thScale   - Scalar.
    %
    % particles - Struct array with fields ('pose').
    
    xMax = max(support.xv);
    xMin = min(support.xv);
    yMax = max(support.yv);
    yMin = min(support.yv);
    xGrid = xMin:xyScale:xMax;
    yGrid = yMin:xyScale:yMax;
    particles = struct('pose',{});
    thArray = 0:thScale:2*pi;
    
    count = 1;
    for i = 1:length(xGrid)
        for j = 1:length(yGrid)
            x = xGrid(i); y = yGrid(j);
            tBBox = transformPolygon([x; y; 0],bBox);
            if isValidPose(map,support,tBBox)
                for k = 1:length(thArray)
                    pose = [x; y; thArray(k)];
                    particles(count).pose = pose;
                    count = count+1;
                end
            end
        end
    end
end