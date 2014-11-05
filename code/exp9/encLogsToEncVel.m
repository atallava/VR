function [vlCell,vrCell] = encLogsToEncVel(encLogs)
%ENCLOGSTOENCVEL 
% 
% [vlCell,vrCell] = ENCLOGSTOENCVEL(encLogs)
% 
% encLogs - 
% 
% vlCell  - 
% vrCell  - 

[vlCell,vrCell] = deal(cell(1,length(encLogs)));
for i = 1:length(encLogs)
	log = encLogs(i).log;
	left = [log.left]; right = [log.right];
	dt = encLogs(i).tArray(2:end)-encLogs(i).tArray(1:end-1);
	vl = left(2:end)-left(1:end-1); vl = vl./dt;
	vr = right(2:end)-right(1:end-1); vr = vr./dt;
	vlCell{i} = vl; vrCell{i} = vr;
end

end