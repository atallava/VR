function obj = f1Obj(data,params)
%F1OBJ 
% 
% obj = F1OBJ(data,params)
% 
% data   - 
% params - 
% 
% obj    - 

targetLength = 0.61;
load target_lines_by_conf
nMin = params.nMin;
errorThresh = params.errorThresh;
lineCandAlgo = @(x1,x2,x3,x4) lineCand(x1,x2,x3,x4,nMin,errorThresh);

nData = length(data.X);
% getPR needs a cell of scans
% here, scan{i} is one range reading only
nBearings = length(data.Y(1).ranges);
scans = [data.Y.ranges];
scans = reshape(scans,nBearings,nData)';
scans = mat2cell(scans,ones(1,nData),nBearings);

[nDetected,nCorrect,nTargets] = getPR(scans,targetLength,targetLinesByConf,lineCandAlgo);
p = sum(nCorrect)/sum(nDetected);
r = sum(nCorrect)/sum(nTargets);
obj = 2*p*r/(p+r);
    
end