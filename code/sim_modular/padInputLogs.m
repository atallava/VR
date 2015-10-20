function [inputVlLog,inputVrLog,tInputV] = padInputLogs(inputVlLog,inputVrLog,tInputV,duration)
%PADINPUTLOGS Pad velocity logs with zeros to cover duration.
% 
% [inputVlLog,inputVrLog,tInputV] = PADINPUTLOGS(inputVlLog,inputVrLog,tInputV,duration)
% 
% inputVlLog - Input Vl array.
% inputVrLog - Input Vr array.
% tInputV    - Input time array.
% duration   - Duration of experiment.
% 
% inputVlLog - Padded array.
% inputVrLog - ''
% tInputV    - ''

padDuration = duration-(tInputV(end)-tInputV(1));
if padDuration < 0
	return;
end
period = tInputV(end)-tInputV(end-1); % Arbitrary period.
count = ceil(padDuration/period)+1;
tInputV = [tInputV tInputV(end)+period*[1:count]];
inputVlLog = [inputVlLog zeros(1,count)];
inputVrLog = [inputVrLog zeros(1,count)];
end

