function obj = algoObj(X,Y,params)
%ALGOOBJ Negative F1 score.
% 
% obj = ALGOOBJ(data,params)
% 
% X      - Struct array.
% Y      - Struct array.
% params - 
% 
% obj    - 

debugFlag = true;

load('data/target_length','targetLength');
nMin = params.nMin;
errorThresh = params.errorThresh;
lineCandAlgo = @(x1,x2,x3,x4) lineCand(x1,x2,x3,x4,nMin,errorThresh);

nData = length(X);
% getPR needs a cell of scans
% here, scan{i} is one range reading only
nBearings = length(Y(1).ranges);
scans = [Y.ranges];
scans = reshape(scans,nBearings,nData)';
scans = mat2cell(scans,ones(1,nData),nBearings);
% getPR needs targetLines packaged
targetLinesByConf = cell(1,nData);
for i = 1:nData
    targetLinesByConf{i} = X(i).targetLines;
end

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
    obj = -2*p*r/(p+r);
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