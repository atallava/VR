function hfig = plotScan(pose,ptsLocal,hfig)
% pose is a length 3 array
% ranges is array of length 360

if nargin < 3
    hfig = figure;
end
set(hfig,'Visible','off');
figure(hfig);
hold on;
ptsWorld = pose2D.transformPoints(ptsLocal,pose);
color = abs(randn(1,3));
color = color/sum(color);
plot(ptsWorld(1,:),ptsWorld(2,:),'LineStyle','none','Marker','.','MarkerSize',15,'Color',color);
hold off;    
end

