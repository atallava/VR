function hf = plotCarvedElements(elements)
%PLOTCARVEDELEMENTS 
% 
% hf = PLOTCARVEDELEMENTS(elements)
% 
% elements - Struct array with fields ('mu','sigma').
% 
% hf       - Figure handle.

hf = figure; hold on; axis equal;
for i = 1:length(elements)
	[x,y] = getEllipsePoints(elements(i).sigma);
	plot(x+elements(i).mu(1),y+elements(i).mu(2),'g','linewidth',2);
end
end

