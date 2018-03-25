load nsh3_corridor
map.plot();
grid on;
set(gca,'xtick',-5:0.5:9)
set(gca,'ytick',-6:0.5:4)
[x,y] = ginput
f = fit(x,y,'smoothingspline');
nPoints = length(x);
wp = zeros(3,nPoints);
wp(:,1) = [x(1); y(1); pi/2];
wp(1,2:end) = x(2:end);
wp(2,2:end) = feval(f,x(2:end));
th = differentiate(f,x(2:end));
wp(3,2:end) = th;
