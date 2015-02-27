function flag = pickObjElements(elements,Tobj2world,objBBox)
%PICKOBJELEMENTS Associate carved elements with object.
% 
% flag = PICKflag(elements,Tobj2world,objBBox)
% 
% elements    - Struct array with fields ('mu','sigma').
% Tobj2world  - Transform from object to world.
% objBBox     - Object bounding box. Struct with fields ('x','y').
% 
% flag        - Logical  array.

mus = [elements(:).mu];
flag = (mus(1,:) >= Tobj2world(1,3)-objBBox.x*0.5) & ...
	(mus(1,:) <= Tobj2world(1,3)+objBBox.x*0.5) & ...
	(mus(2,:) >= Tobj2world(2,3)-objBBox.x*0.5) & ...
	(mus(2,:) <= Tobj2world(2,3)+objBBox.x*0.5);
end

