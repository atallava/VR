function fname = buildDataFileName(source,tag,date,index,format)
%BUILDDATAFILENAME 
% 
% fname = BUILDDATAFILENAME(source,tag,date,index,format)
% 
% source - Robot name.
% tag    - 'traj','tfcalib' etc.
% date   - yymmdd string.
% index  - ...
% format - .mat by default.
% 
% fname  - Output.

if nargin < 5
	format = '.mat';
end
if ~ischar(index)
	index = num2str(index);
end

fname = ['data_' source '_' tag '_' date '_' index format];
end

