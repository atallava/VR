function fileName = buildDataFileName(inputStruct)
%BUILDDATAFILENAME 
% 
% fileName = BUILDDATAFILENAME(source,tag,date,index,format)
% 
% source - Robot name.
% tag    - 'traj','tfcalib' etc.
% date   - yymmdd string.
% index  - ...
% format - .mat by default.
% 
% fileName  - Output.

% default, no prefix
if ~isfield(inputStruct,'pre')
    inputStruct.pre = '';
end
% default, matlab data file
if ~isfield(inputStruct,'format')
    inputStruct.format = '.mat';
end
% prepend dot to extension 
if isempty(strcmp(inputStruct.format,'.'))
    inputStruct.format = ['.' inputStruct.format];
end
% default, no index
if ~isfield(inputStruct,'index')
    inputStruct.index = '';
end
% index may be number
if ~ischar(inputStruct.index)
	inputStruct.index = num2str(inputStruct.index);
end

if ~isempty(inputStruct.pre)
    fileName = [inputStruct.pre '/'];
else
    fileName = [];
end
fileName = [fileName 'data_' ...
    inputStruct.source '_' ...
    inputStruct.tag '_' ...
    inputStruct.date];
if ~isempty(inputStruct.index)
    fileName = [fileName '_' inputStruct.index];
end
fileName = [fileName inputStruct.format];
end

