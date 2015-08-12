function [intervalsPub,intervalsSub,delays] = getTimeIntervals(fname)
%GETTIMEINTERVALS 
% 
% [intervalsPub,intervalsSub,delays] = GETTIMEINTERVALS(fname)
% 
% fname        - File name. Contains encHistArray or lzrHistArray.
% 
% intervalsPub - Intervals of published messages.
% intervalsSub - Intervals of subscribed messages.
% delays       - Delays between subscribed and published.


% Supress during file load.
warning('off'); 
load(fname);
intervalsPub = [];
intervalsSub = [];
delays = [];
if exist('encHistArray','var')
	histArray = encHistArray;
elseif exist('lzrHistArray','var')
	histArray = lzrHistArray;
else
	warning('FILE MUST CONTAIN ENCHISTARRAY OR LZRHISTARRAY');
end

for i = 1:length(histArray)
	tRob = histArray(i).tArray;
	tLocal = histArray(i).tLocalArray;
	ivlPub = tRob(2:end)-tRob(1:end-1);
	intervalsPub = [intervalsPub ivlPub];
	
	ivlSub = tLocal(2:end)-tLocal(1:end-1);
	intervalsSub = [intervalsSub ivlSub];
	
	% constrain tLocal > tRob
	offset = max(tRob-tLocal);
	dt = tLocal-(tRob-offset);
	delays = [delays dt];
end
end