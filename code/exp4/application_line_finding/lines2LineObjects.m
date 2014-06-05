function lObjArray = lines2LineObjects(lines)
% lines is a sruct ('p1','p2') array
% lObjArray is an array of lineObjects

lObjArray = lineObject.empty(0,length(lines));
for i = 1:length(lines)
   lObjArray(i) = lineObject();
   lObjArray(i).lines = [lines(i).p1'; lines(i).p2'];
end

end

