function [dynamicMap,dynamicPoses] = genDynamicMap(baseMap,supports,dynamicBBox,minDynamicObjects,maxDynamicObjects)
    %GENDYNAMICMAP
    %
    % [dynamicMap,dynamicPoses] = GENDYNAMICMAP(baseMap,supports,dynamicBBox,minDynamicObjects,maxDynamicObjects)
    %
    % baseMap           - lineMap object.
    % supports          - Array of vertex structs.
    % dynamicBBox       - Vertex struct. 
    % minDynamicObjects - Scalar.
    % maxDynamicObjects - Scalar.
    %
    % dynamicMap        - lineMap object.
    % dynamicPoses      - [3,nPoses] array.
    
    % copy base map
    dynamicMap = lineMap(baseMap.objects);

    dynamicPoses = [];
    % loop over supports
    for support = supports
        nDynamicObjects = randsample(minDynamicObjects:maxDynamicObjects,1);
        dynamicPoses = [dynamicPoses; ...
            uniformSamplesOnSupport(baseMap,support,dynamicBBox,nDynamicObjects)];
        for i = 1:nDynamicObjects
            tBBox = transformPolygon(dynamicPoses(i,:),dynamicBBox);
            dynamicObject = vertexStructToLineObject(tBBox);
            dynamicMap.addObject(dynamicObject);
        end
    end
end