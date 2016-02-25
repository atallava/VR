function obj = vertexStructToLineObject(vertexStruct)
    %VERTEXSTRUCTTOLINEOBJECT
    %
    % obj = VERTEXSTRUCTTOLINEOBJECT(vertexStruct)
    %
    % vertexStruct - Struct with fields ('xv','yv').
    %
    % obj          - lineObject object

    nVertices = length(vertexStruct.xv);
    obj = lineObject();
    obj.lines = zeros(nVertices,2);
    obj.lines(:,1) = vertexStruct.xv;
    obj.lines(:,2) = vertexStruct.yv;
end