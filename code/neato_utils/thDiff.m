function dTh = thDiff(th1,th2)
%THDIFF Difference between two angles in radian.
% Difference is angle from th1 to th2.
%
% dTh = THDIFF(th1,th2)
% 
% th1 - Vector of angles.
% th2 - Vector of angles of same size as th1.
% 
% dTh - Vector of angles of same size as th1. Results in [-pi,pi].

dTh = atan2(sin(th2-th1),cos(th2-th1));
end