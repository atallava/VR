function tStart = calcMotionStartTime(x,timeStamps,windowSize,threshold)
%CALCMOTIONSTARTTIME Calculate time when there is a significant change in x for the first
% time. Assumed that there is leading stasis. 
% tStart = CALCMOTIONSTARTTIME(x,timeStamps,windowSize,threshold)
% 
% x          - 
% timeStamps - 
% windowSize - 
% threshold  - 
% 
% tStart     - 

if nargin < 4
	windowSize = 5; 
	threshold = 3e-4;
end

% smoothed difference in x
xdiff = smoothDiff(x,windowSize);
ids = find(abs(xdiff) >= threshold);
id = ids(1)+windowSize;
tStart = timeStamps(id);
end