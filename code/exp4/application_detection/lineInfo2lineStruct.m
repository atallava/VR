function lineStruct = lineInfo2lineStruct(ri,lineInfo)
%LINEINFO2LINESTRUCT 
% 
% lineStruct = LINEINFO2LINESTRUCT(lineInfo)
% 
% lineInfo   - Struct or cell array of structs with fields
%              ('err','th','num','left','right').
% 
% lineStruct - Struct array with fields ('p1','p2').

if ~iscell(lineInfo)
    p1id = lineInfo.left; 
    p2id = lineInfo.right;
    
    lineStruct.p1 = [ri.xArray(p1id) ri.yArray(p1id)]; 
    lineStruct.p2 = [ri.xArray(p2id) ri.yArray(p2id)];
    return;
end

nLines = length(lineInfo);
for i = 1:nLines
    p1id = lineInfo{i}.left; 
    p2id = lineInfo{i}.right;
    lineStruct(i).p1 = [ri.xArray(p1id) ri.yArray(p1id)]; 
    lineStruct(i).p2 = [ri.xArray(p2id) ri.yArray(p2id)];
end


end