function dists = distToLine2D(pts, line)
% pts is a nx2 array, n: number of points
% line is a 3x1 column vector
% dists is nx1
A = pts; A(:,end+1) = ones(size(pts,1),1);
dists = A*line;
dists = abs(dists)/norm(line(1:2));
end
