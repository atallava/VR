function updatePlot(src,evt,hp)
th = deg2rad(linspace(-120,120,682));
ranges = evt.data*1e-3;
set(hp,'xdata',ranges.*cos(th),'ydata',ranges.*sin(th));
end

