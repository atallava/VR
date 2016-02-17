function hf = plotPath(desiredPath)
   x = [desiredPath.x];
   y = [desiredPath.y];
   hf = figure;
   plot(x,y,'-');
   axis equal;
   xlabel('x');
   ylabel('y');
end