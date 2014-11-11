function dataEncVel = getDataEncVel(dataCommVel,encLogs)
%GETDATAENCVEL 
% 
% dataEncVel = GETDATAENCVEL(dataCommVel,encLogs)
% 
% dataCommVel - 
% encLogs     - 
% 
% dataEncVel  - 

dataEncVel = struct('startPose',{},'finalPose',{},'vlArray',{},'tArray',{});
[vl,vr] = encLogsToEncVel(encLogs);
for i = 1:length(dataCommVel)
	dataEncVel(i).startPose = dataCommVel(i).startPose;
	dataEncVel(i).finalPose = dataCommVel(i).finalPose;
	dataEncVel(i).vlArray = vl{i};
	dataEncVel(i).vrArray = vr{i};
	dataEncVel(i).tArray = encLogs(i).tArray(2:end);
end

end