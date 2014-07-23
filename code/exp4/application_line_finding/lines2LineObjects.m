function lObjArray = lines2LineObjects(lines)
%LINES2LINEOBJECTS 
% 
% lObjArray = LINES2LINEOBJECTS(lines)
% 
% lines     - Struct array with fields ('p1','p2').
% 
% lObjArray - Array of lineObject objects.

lObjArray = lineObject.empty(0,length(lines));
for i = 1:length(lines)
   lObjArray(i) = lineObject();
   lObjArray(i).lines = [lines(i).p1'; lines(i).p2'];
end

end

