function hfig = plotScan(pose,ptsLocal,hfig)
% pose is an object of class pose2D
% ranges is array of length 360

if nargin < 3
    hfig = figure;
end
set(hfig,'Visible','off');
figure(hfig);
hold on;
ptsWorld = pose.Tb2w()*ptsLocal;
color = abs(randn(1,3));
color = color/sum(color);
plot(ptsWorld(1,:),ptsWorld(2,:),'LineStyle','none','Marker','.','MarkerSize',15,'Color',color);
hold off;    
end

