function dataEncVel = getDataEncVel(dataCommVel,encLogs)
%GETDATAENCVEL 
% 
% dataEncVel = GETDATAENCVEL(dataCommVel,encLogs)
% 
% dataCommVel - 
% encLogs     - 
% 
% dataEncVel  - 

dataEncVel = struct('startPoses',{},'finalPoses',{},'vlArray',{},'tArray',{});
[vl,vr] = encLogsToEncVel(encLogs);
for i = 1:length(dataCommVel)
	dataEncVel(i).startPose = dataCommVel(i).startPose;
	dataEncVel(i).finalPose = dataCommVel(i).finalPose;
	dataCommVel(i).vlArray = vl{i};
	dataCommVel(i).vrArray = vr{i};
	dataCommVel(i).tArray = encLogs(i).tArray(2:end);
end

end