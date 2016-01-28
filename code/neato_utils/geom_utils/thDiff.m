function dTh = thDiff(varargin)
%THDIFF Difference between two angles in radian.
% Difference is angle from th1 to th2.
%
% dTh = THDIFF(th)
% dTh = THDIFF(th1,th2)
%
% th  - Vector of angles
% 
% th1 - Vector of angles.
% th2 - Vector of angles of same size as th1.
% 
% dTh - Vector of angles of same size as th1. Results in [-pi,pi].

switch nargin
    case 1
        thVec = varargin{1};
        th1 = thVec(1:end-1);
        th2 = thVec(2:end);
    case 2
        th1 = varargin{1};
        th2 = varargin{2};
    otherwise
        error('thDiff:invalidInput','Invalid input. See help.');
end

dTh = atan2(sin(th2-th1),cos(th2-th1));
end