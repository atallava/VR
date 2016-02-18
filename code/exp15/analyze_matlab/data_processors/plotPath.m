function hf = plotPath(desiredPath)
   x = desiredPath.pts(:,1);
   y = desiredPath.pts(:,2);
   hf = figure;
   plot(x,y,'-');
   axis equal;
   xlabel('x');
   ylabel('y');
end