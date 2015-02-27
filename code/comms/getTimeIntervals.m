function intervals = getTimeIntervals(fname)
%GETTIMEINTERVALS 
% 
% intervals = GETTIMEINTERVALS(fname)
% 
% fname     - File name. Contains encHistArray or lzrHistArray.
% 
% intervals - Array of communication intervals.


% Supress during file load.
warning('off'); 
load(fname);
intervals = [];
if exist('encHistArray','var')
	histArray = encHistArray;
elseif exist('lzrHistArray','var')
	histArray = lzrHistArray;
else
	warning('FNAME MUST CONTAIN ENCHISTARRAY OR LZRHISTARRAY');
end

for i = 1:length(histArray)
	ivl = histArray(i).tArray(2:end)-histArray(i).tArray(1:end-1);
	intervals = [intervals ivl];
end
end