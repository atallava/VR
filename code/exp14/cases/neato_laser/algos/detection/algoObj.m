function obj = algoObj(data,params)
%ALGOOBJ F1 score.
% 
% obj = ALGOOBJ(data,params)
% 
% data   - 
% params - 
% 
% obj    - 

debugFlag = true;

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

clockLocal = tic;
[nDetected,nCorrect,nTargets] = getPR(scans,targetLength,targetLinesByConf,lineCandAlgo);
if (sum(nDetected) == 0) && (sum(nCorrect) == 0)
    p = 0;
else
    p = sum(nCorrect)/sum(nDetected);
end
r = sum(nCorrect)/sum(nTargets);
if (p == 0) && (r == 0)
    obj = 0;
else
    obj = 2*p*r/(p+r);
end
tComp = toc(clockLocal);

if debugFlag
    fprintf('algoObj:Computation time: %.2fs.\n',tComp);
end
if isnan(obj)
    error('algoObj:invalidObjectiveValue','Objective is nan.');
end
if isinf(obj)
    error('algoObj:invalidObjectiveValue','Objective is inf.');
end
    
end