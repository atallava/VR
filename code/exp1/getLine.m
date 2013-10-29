function [avg_error, line] = getLine(pts)
%pts is an nx2 array, where n is the number of points
%returns least-squares fit line
A = pts; A(:,end+1) = ones(length(pts),1);
[eigenvecs, ~] = eig(A'*A);
line = eigenvecs(:,1);
distances = (A*line)/norm(line(1:2));
distances = abs(distances);
avg_error = sum(distances)/length(distances);
end
