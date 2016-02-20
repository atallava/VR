function updatePlot(src,evt,hp)
%UPDATEPLOT Use as listener for real-time range plot.
% 
% UPDATEPLOT(src,evt,hp)
% 
% src - 
% evt - 
% hp  - Figure handle.

th = deg2rad(linspace(-120,120,682));
ranges = evt.data;
set(hp,'xdata',ranges.*cos(th),'ydata',ranges.*sin(th));
end

