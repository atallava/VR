function mapNew = addBBoxToMap(mapOld,bBox,pose)
    %ADDBBOXTOMAP
    %
    % mapNew = ADDBBOXTOMAP(mapOld,bBox)
    % mapNew = ADDBBOXTOMAP(mapOld,bBox,pose)
    %
    % mapOld - lineMap object.
    % bBox   - Struct with fields ('xv','yv').
    % pose   - Length 3 vector. Transforms bBox. Optional.
    %
    % mapNew - lineMap object.
    
    condn = isVertexStruct(bBox);
    assert(condn,'bBox must be vertex struct');
        
    if nargin > 2
        % is pose provided, transform bBox
        bBox = transformPolygon(pose,bBox);
    end
    
    % copy old map and add object
    mapNew = lineMap(mapOld.objects);
    newObj = vertexStructToLineObject(bBox);
    mapNew.addObject(newObj);
end