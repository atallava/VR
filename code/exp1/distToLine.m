function dists = distToLine(pts, line)
%pt is a nx2 array, n: number of points
%line is a 3x1 column vector
A = pts; A(:,end+1) = ones(size(pts,1),1);
dists = A*line;
dists = abs(dists)/norm(line(1:2));
end
