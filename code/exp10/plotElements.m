function hf = plotElements(elements)
hf = figure;
axis equal;
hold on;
for i = 1:length(elements)
    [x,y] = getEllipsePoints(elements(i).sigma);
    plot(x+elements(i).mu(1),y+elements(i).mu(2),'g','linewidth',2);
end
end