function p2Array = interpTrajectory(p1Array,t1Array,t2Array)
%INTERPTRAJECTORY 
% 
% p2Array = INTERPTRAJECTORY(p1Array,t1Array,t2Array)
% 
% p1Array - [3,length(t1Array)] size pose array.
% t1Array - Timestamps for p1Array.
% t2Array - Desired times.
% 
% p2Array - [3,length(t2Array)] size pose array.

p2Array(1,:) = interp1(t1Array,p1Array(1,:),t2Array);
p2Array(2,:) = interp1(t1Array,p1Array(2,:),t2Array);
p2Array(3,:) = interp1(t1Array,p1Array(3,:),t2Array);
end