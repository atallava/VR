function processMocapData(robotName,tag,dateStr,indices,tfCalibFile)
%PROCESSMOCAPDATA Processes mocap data using transform calibration to
% generate timestamped state estimates.
%
% PROCESSMOCAPDATA(robotName,tag,dateStr,indices,tfCalibFile)
%
% robotName   -
% tag         -
% dateStr     -
% indices     -
% tfCalibFile -

for i = 1:length(indices)
	fprintf('Index: %d\n',i);
	index = indices(i);
	processMocapDataScript;
end
end