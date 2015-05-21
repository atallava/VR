function dataEncVel = getDataEncVel(dataCommVel,encLogs)
%GETDATAENCVEL Generate data structure with encoder velocity logs.
% 
% dataEncVel = GETDATAENCVEL(dataCommVel,encLogs)
% 
% dataCommVel - Struct array, fields ('startPose','finalPose','vlArray','tArray')
% encLogs     - Struct array, fields ('log','tArray')
% 
% dataEncVel  - Struct array, fields ('startPose','finalPose','vlArray','tArray')

dataEncVel = struct('startPose',{},'finalPose',{},'vlArray',{},'vrArray',{},'tArray',{});
[vl,vr] = encLogsToEncVel(encLogs);
for i = 1:length(dataCommVel)
	dataEncVel(i).startPose = dataCommVel(i).startPose;
	dataEncVel(i).finalPose = dataCommVel(i).finalPose;
	dataEncVel(i).vlArray = vl{i};
	dataEncVel(i).vrArray = vr{i};
	dataEncVel(i).tArray = encLogs(i).tArray(2:end);
end

end