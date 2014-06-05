function line = fixLineLength(line,L)
% line is struct('p1','p2')

midpoint = mean([line.p1 line.p2],2);
segment = line.p2-line.p1;
th = atan2(segment(2),segment(1));
dp = L*0.5*[cos(th); sin(th)];
line.p1 = midpoint+dp;
line.p2 = midpoint-dp;
end

